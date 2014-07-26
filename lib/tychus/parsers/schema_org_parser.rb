module Tychus
module Parsers

  class SchemaOrgParser < Base

    def initialize(uri)
      super
      strip_review_microformat
      strip_video_object_microformat
    end

    def strip_review_microformat
      recipe_doc.css(self.class.review_doc).remove
    end

    def strip_video_object_microformat
      recipe_doc.css(self.class.video_object_doc).remove
    end


    def self.root_doc
      '[itemtype="http://schema.org/Recipe"]'
    end

    def itemprop_node_for(property)
      "[itemprop='#{property}']"
    end

    def self.review_doc
      '[itemtype="http://schema.org/Review"]'
    end

    def self.video_object_doc
      '[itemtype="http://www.schema.org/VideoObject"]'
    end

  end

end
end

