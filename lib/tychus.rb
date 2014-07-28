require "tychus/version"
require "tychus/parsers"
require "tychus/parser_selector"
require "tychus/uri_resolver"
require "tychus/meta_parser"

module Tychus
  def self.parse(uri)
    meta_object = MetaParser.new(uri).parse
    parser = ParserSelector.resolve_parser(meta_object)
    parser.new(uri).parse
  end
end
