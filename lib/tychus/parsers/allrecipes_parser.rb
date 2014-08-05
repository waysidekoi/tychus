module Tychus
module Parsers

  class AllrecipesParser < SchemaOrgParser
    def self.uri_host
      "allrecipes.com"
    end

    def parse_recipe_instructions
      #reject last "Kitchen Friendly View" element
      instructions = super
      instructions[0..-2]
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
  end

end
end

