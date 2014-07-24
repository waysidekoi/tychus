module Tychus
module Parsers

  # Allrecipes uses schema.org's recipe microformat
  class AllrecipesParser < SchemaOrgParser
    def self.uri_host
      "allrecipes.com"
    end
  end

end
end

