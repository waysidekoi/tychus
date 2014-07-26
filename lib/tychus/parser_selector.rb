module Tychus
  class ParserSelector
    PARSERS = [
      Tychus::Parsers::AllrecipesParser,
      Tychus::Parsers::FoodNetworkParser
    ]

    def self.resolve_parser(host)
      PARSERS.detect do |parser|
        host =~ %r[#{parser.uri_host}]
      end
    end

  end
end

