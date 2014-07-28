module Tychus
module Parsers

  class AllrecipesParser < SchemaOrgParser
    def self.uri_host
      "allrecipes.com"
    end

    def clean_instructions(instructions)
      #reject last "Kitchen Friendly View" element
      instructions[0..-2]
    end
  end

end
end

