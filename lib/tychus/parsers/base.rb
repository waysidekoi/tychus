require 'active_support/core_ext/object/blank.rb'

module Tychus
module Parsers

  class Base
    attr_reader :uri, :doc, :recipe_doc, :recipe

    def self.recipe_attributes
      # TODO: clear up these attributes. Are they used? Real example to
      # verify?
        # recipeType
        # photo
        # published
        # summary
        # review - see schema.org/Review
      %i[
        name
        author
        description
        prep_time
        cook_time
        total_time
        recipe_yield
        ingredients
        recipe_instructions
        image
      ]
    end

    def initialize(uri)
      @uri = uri
      @recipe = Recipe.new
      @doc = Nokogiri::HTML(open(uri))
      @recipe_doc = @doc.css(self.class.root_doc)
    end

    def parse
      recipe_attributes.each do |attr|
        property_value = __send__("parse_#{attr}")
        recipe.__send__("#{attr}=", Value(property_value))
      end
      recipe
    end

    def parse_author
      # is it always first?
      itemprop_node_for(:author).content
    end

    def parse_description
      # is it always first?
      itemprop_node_for(:description).content
    end

    def parse_recipe_instructions
      # strip empty strings, drop trailing whitespace, clean carriage returns (\r\n)
      #
      # Allrecipes: <li><span>lorem ipsum</span></li>
      # FoodNetwork: <p>lorem ipsum</p>
      # reject headers such as "Directions" and divs such as .categories for Foodnetwork recipes
      reject_regex = /^(h.|div)$/

      clean_instructions(itemprop_node_for(:recipeInstructions)
        .element_children
        .reject { |node| node.name =~ reject_regex }
        .map do |node|
          node.content
            .squeeze(" ")
            .rstrip
            .split("\r\n\s\r\n\s")
        end.flatten.reject(&:blank?))
    end

    def parse_name
      # is it always first?
      itemprop_node_for(:name).content
    end

    def parse_cook_time
      # is it always first?
      # leverage iso8601
      parse_duration(itemprop_node_for(:cookTime))
    end

    def parse_image
      # is it always first?
      itemprop_node_for(:image).attr('src')
    end

    def parse_ingredients
      # NOT FIRST
      recipe_doc
        .css('[itemprop="ingredients"]')
        .map do |ingredient_node|
          ingredient_node
            .element_children
            .map(&:content)
            .join(" ")
        end.reject(&:blank?)
    end

    def parse_prep_time
      # is it always first?
      # leverage iso8601
      parse_duration(itemprop_node_for(:prepTime))
    end

    def parse_duration(node)
      # Allrecipes - 'time' element
      # Foodnetwork - 'meta' element (std according to
      # Schema.org/Recipe)
      case node.name
      when "meta", "span"
        node.attr('content')
      when "time"
        node.attr('datetime')
      else
        NullObject.new
      end
    end

    def parse_recipe_yield
      # is it always first?
      itemprop_node_for(:recipeYield).content
    end

    def parse_total_time
      # is it always first?
      # leverage iso8601
      parse_duration(itemprop_node_for(:totalTime))
    end

    def recipe_attributes
      self.class.recipe_attributes
    end

    def clean_instructions(obj)
      obj
    end

    def Value(obj)
      case obj
      when NullObject then nil
      else obj
      end
    end
  end

  class NullObject
    def method_missing(*args, &block)
      self
    end
  end

end
end
