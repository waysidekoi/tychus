require "tychus/version"
require "tychus/parsers"
require "tychus/parser_selector"
require "tychus/uri_resolver"

module Tychus
  def self.parse(uri)
    host = URIResolver.new(uri).resolve_uri
    parser = ParserSelector.resolve_parser(host)
    parser.new(uri).parse
  end
end
