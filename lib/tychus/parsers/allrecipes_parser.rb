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
  end

end
end

