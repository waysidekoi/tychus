require 'active_support/core_ext/object/blank.rb'

module Tychus
module Parsers

  class Base
    attr_reader :uri, :recipe_doc, :recipe

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
        prep_time
        cook_time
        total_time
        recipe_yield
        ingredients
        recipe_instructions
      ]
    end

    def initialize(uri)
      @uri = uri
      @recipe = Recipe.new
    end

    def doc
      Nokogiri::HTML(open(uri))
    end

    def parse
      recipe_attributes.each do |attr|
        value = __send__("parse_#{attr}")
        recipe.__send__("#{attr}=", value)
      end
      recipe
    end

    def parse_author
      # is it always first?
      recipe_doc.css(itemprop_node_for(:author)).first.content
    end

    def parse_recipe_instructions
      # strip empty strings, clean carriage returns (\r\n), reject last
      # "Kitchen Friendly View" element
      recipe_doc.css(itemprop_node_for(:recipeInstructions)).css('[itemprop="recipeInstructions"]').first.element_children.map{|x|x.content.squeeze(" ").split("\r\n\s\r\n\s")}.flatten.reject(&:blank?)[0..-2]
    end

    def parse_name
      # is it always first?
      recipe_doc.css(itemprop_node_for(:name)).first.content
    end

    def parse_cook_time
      # is it always first?
      # leverage iso8601
      recipe_doc.css(itemprop_node_for(:cookTime)).first["datetime"]
    end

    def parse_ingredients
      # NOT FIRST
      recipe_doc.css(itemprop_node_for(:ingredients)).map{|ingredient_node| ingredient_node.element_children.map(&:content).join(" ")}.reject(&:blank?)
    end

    def parse_prep_time
      # is it always first?
      # leverage iso8601
      recipe_doc.css(itemprop_node_for(:prepTime)).first["datetime"]
    end

    def parse_recipe_yield
      # is it always first?
      recipe_doc.css(itemprop_node_for(:recipeYield)).first.content
    end

    def parse_total_time
      # is it always first?
      # leverage iso8601
      recipe_doc.css(itemprop_node_for(:totalTime)).first["datetime"]
    end

    def recipe_attributes
      self.class.recipe_attributes
    end

    def recipe_doc
      @recipe_doc ||= doc.css(self.class.root_doc)
    end

  end

  class NullObject
    def method_missing(*args, &block)
      nil
    end
  end

end
end

