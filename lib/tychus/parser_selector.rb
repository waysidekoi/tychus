module Tychus
  class ParserSelector
    PARSERS = [
      Tychus::Parsers::AllrecipesParser,
      Tychus::Parsers::FoodNetworkParser,
      Tychus::Parsers::KraftRecipesParser,
      Tychus::Parsers::CampbellsKitchenParser
    ]

    def self.resolve_parser(meta_object)
      PARSERS.detect do |parser|
        meta_object.to_s =~ %r[#{parser.uri_host}]
      end
    end

  end
end

