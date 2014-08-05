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
        if meta_object.schema_org_microformat?
          return Tychus::Parsers::SchemaOrgParser
        end

        raise("No parser found")
      end
      parser
    end

  end
end

