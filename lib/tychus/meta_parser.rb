# This MetaParser returns a Meta object, which contains attributes the
# ParserSelector will check against to select the appropriate parser

require 'nokogiri'
require 'open-uri'

module Tychus
  Meta = Struct.new(:uri_object, :open_graph_protocol, :schema_org_microformat) do
    alias_method :schema_org_microformat?, :schema_org_microformat

    def uri; uri_object.to_s; end
    def host; uri_object.host; end
    def open_graph_protocol?; open_graph_protocol.present?; end
  end

  class MetaParser
    attr_reader :meta, :doc

    def initialize(uri)
      @uri = uri
      @meta = Meta.new
      @doc = Nokogiri::HTML(open(uri))
    end

    def parse
      set_uri
      set_open_graph_protocol
      set_schema_org_microformat

      meta
    end

    def set_open_graph_protocol
      protocol = doc.css('html').first.attr('xmlns:og')

      meta.__send__("open_graph_protocol=", protocol)
    end

    def set_schema_org_microformat
      schema_org_property = '[itemtype="http://schema.org/Recipe"]'
      nodeset = doc.css(schema_org_property)

      meta.__send__("schema_org_microformat=", nodeset.present?)
    end

    def set_uri
      r = URIResolver.new(@uri, doc)
      uri_object = r.resolve_uri

      meta.uri_object = uri_object
    end
  end

end

