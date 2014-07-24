# This will attempt to resolve a host for the uri
# by first attempting to resolve its canonical uri (if it exists)
# and then will return the uri's host and the parsed nokogiri object
# Since in order to get the canonical uri, we have to use Nokogiri to 
# find a link tag, is it too much to expect this class to act as an
# uri parser (using Addressable) and a Nokogiri object maker?

require 'addressable/uri'
require 'open-uri'

module Tychus
  class URIResolver
    attr_reader :uri, :doc

    def initialize(uri)
      @uri = uri
      @schema_org_canonical_uri_property = 'link[rel="canonical"]'
      @open_graph_canonical_uri_property = 'meta[property="og:url"]'
      @doc = Nokogiri::HTML(open(uri))
    end

    def resolve_uri
      # try to retrieve host from canonical uri in markup
      # else resort to given uri
      canonical_uri(schema_org_canonical_uri_property).presence || \
      canonical_uri(open_graph_canonical_uri_property) || \
      Addressible::URI.parse(uri).host
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
