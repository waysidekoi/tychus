module Tychus
module Parsers

  # Allrecipes uses schema.org's recipe microformat
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

