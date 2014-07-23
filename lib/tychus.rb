require "tychus/version"
require "tychus/parsers"
require "tychus/parser_selector"

module Tychus
  def parse(uri)
    parser = ParserSelector.new(uri).resolve_parser
    parser.new(uri).parse
  end
end
