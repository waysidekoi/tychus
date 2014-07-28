# URIs using FB's open graph protocol store all recipe values
# within their <head>, as meta tags with 'property' attributes:
# * og:url
# * og:title
# * og:image

module Tychus
module Parsers
  class OpenGraphProtocolParser
    def initialize(uri)
      @root_doc = 'head'
      @recipe_doc = @doc.css(root_doc)
    end

    def parse_image
      og_node_for(:image)
    end

    def parse_name
      og_node_for(:title)
    end

    def parse_description
      recipe_doc.css('meta[name="description"]').first.attr('content')
    end

    def og_node_for(property)
      node = recipe_doc.css('meta[property=\"og:#{property}\"]').first
      node.attr('content')
    end
  end
end
end


