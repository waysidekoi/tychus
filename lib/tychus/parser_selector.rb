module Tychus
  class ParserSelector
    PARSERS = [
      Tychus::Parsers::AllrecipesParser,
      Tychus::Parsers::FoodNetworkParser,
      Tychus::Parsers::KraftRecipesParser,
      Tychus::Parsers::CampbellsKitchenParser
    ]

    def self.resolve_parser(meta_object)
      parser = PARSERS.detect do |parser|
        meta_object.to_s =~ %r[#{parser.uri_host}]
      end

      if parser.blank?
        return Tychus::Parsers::SchemaOrgParser if meta_object.schema_org_microformat?
      end

      parser || Tychus::Parsers::IngredientsTextParser
    end

  end
end

