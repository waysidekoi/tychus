# This will attempt to resolve a host for the uri
# by first attempting to resolve its canonical uri (if it exists) else
# uses Addressable::URI#parse

require 'addressable/uri'
require 'open-uri'
require 'nokogiri'
require 'active_support/core_ext/object/blank.rb'

module Tychus
  class URIResolver
    attr_reader :uri, :doc, :schema_org_canonical_uri_property, :open_graph_canonical_uri_property

    def initialize(uri)
      @uri = uri
      @schema_org_canonical_uri_property = 'link[rel="canonical"]'
      @open_graph_canonical_uri_property = 'meta[property="og:url"]'
      @doc = Nokogiri::HTML(open(uri))
    end

    def resolve_uri
      # try to retrieve host from canonical uri in markup
      # else resort to given uri
      full_uri = canonical_uri(schema_org_canonical_uri_property).presence || \
      canonical_uri(open_graph_canonical_uri_property).presence || \
      uri

      Addressable::URI.parse(full_uri).host
    end

    def canonical_uri(property)
      case property
      when schema_org_canonical_uri_property
        doc.css(property).first['href']
      when open_graph_canonical_uri_property
        doc.css(property).first['content']
      end
    end

  end
end
