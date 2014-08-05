module Tychus
module Parsers

  class SchemaOrgParser < Base

    attr_reader :root_doc, :review_doc, :video_object_doc

    def initialize(uri)
      @root_doc = '[itemtype="http://schema.org/Recipe"]'
      @review_doc = '[itemtype="http://schema.org/Review"]'
      @video_object_doc = '[itemtype="http://www.schema.org/VideoObject"]'
      super
      strip_review_microformat
      strip_video_object_microformat
    end

    def itemprop_node_for(property)
      recipe_doc.css("[itemprop='#{property}']").first || NullObject.new
    end

    def parse_author
      itemprop_node_for(:author).content
    end

    def parse_description
      # is it always first?
      itemprop_node_for(:description).content
    end

    def parse_cook_time
      # leverage iso8601
      parse_duration(itemprop_node_for(:cookTime))
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

    def parse_image
      itemprop_node_for(:image).attr('src')
    end

    def parse_ingredients
      # NOT FIRST
      recipe_doc
        .css('[itemprop="ingredients"]')
        .map(&:content)
    end

    def parse_name
      itemprop_node_for(:name).content
    end

    def parse_prep_time
      parse_duration(itemprop_node_for(:prepTime))
    end

    def parse_recipe_instructions
      # strip empty strings, drop trailing whitespace, clean carriage returns (\r\n)
      #
      # Allrecipes: <li><span>lorem ipsum</span></li>
      # FoodNetwork: <p>lorem ipsum</p>
      # reject headers such as "Directions" and divs such as .categories for Foodnetwork recipes
      reject_regex = /^(h.|div)$/

      itemprop_node_for(:recipeInstructions)
        .element_children
        .reject { |node| node.name =~ reject_regex }
        .map do |node|
          node.content
            .squeeze(" ")
            .rstrip
            .split("\r\n\s\r\n\s")
        end.flatten.reject(&:blank?)
    end

    def parse_recipe_yield
      itemprop_node_for(:recipeYield).content
    end

    def parse_total_time
      # leverage iso8601
      parse_duration(itemprop_node_for(:totalTime))
    end

    def strip_review_microformat
      recipe_doc.css(review_doc).remove
    end

    def strip_video_object_microformat
      recipe_doc.css(video_object_doc).remove
    end

  end

end
end

