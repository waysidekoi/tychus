module Tychus
module Parsers
  class FoodNetworkParser < SchemaOrgParser
    def self.uri_host
      "foodnetwork.com"
    end

    def parse_author
      # in the case of an author advertising her TV show
      itemprop_node_for(:author)
        .css('span')
        .first
        .content
    end

    def parse_description
      # Foodnetwork does not use the description in its recipe body
      # resort to opengraph to pull out description in head
      # TODO: pull this func out for an opengraph parser?
      @doc.css('meta[property="og:description"]').first.attr('content')
    end

    def parse_ingredients
      # NOT FIRST
      recipe_doc
        .css('[itemprop="ingredients"]')
        .map { |node| node.content.lstrip.squeeze(" ").chomp } 
    end

    def clean_instructions(obj)
      #TODO: what is best pattern to share this behavior?
      obj
    end

  end
end
end

