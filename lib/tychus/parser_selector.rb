module Tychus
  class ParserSelector
    PARSERS = [
      Tychus::Parsers::AllrecipesParser,
      Tychus::Parsers::FoodNetworkParser,
      Tychus::Parsers::KraftRecipesParser
    ]

    def self.resolve_parser(host)
      PARSERS.detect do |parser|
        host =~ %r[#{parser.uri_host}]
      end
    end

  end
end

