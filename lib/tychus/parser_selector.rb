require 'addressable/uri'

module Tychus
  class ParserSelector
    attr_reader :uri

    PARSERS = [
      Tychus::Parsers::AllrecipesParser
    ]

    def initialize(uri)
      @uri = uri
    end

    def resolve_parser
      uri_object = Addressable::URI.parse(uri)
      host = uri_object.host

      PARSERS.detect do |parser|
        host =~ %r[#{parser.uri_host}]
      end
    end

  end
end

