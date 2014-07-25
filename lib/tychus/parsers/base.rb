module Tychus
module Parsers

  class Base
    attr_reader :uri, :recipe_doc, :recipe

    def self.recipe_attributes
      # TODO: clear up these attributes. Are they used? Real example to
      # verify?
        # recipeType
        # photo
        # published
        # summary
        # review - see schema.org/Review
      %i[
        name
        author
        prep_time
      ]
    end

    def initialize(uri)
      @uri = uri
      @recipe = Recipe.new
    end

    def doc
      Nokogiri::HTML(open(uri))
    end

    def parse
      recipe_attributes.each do |attr|
        value = __send__("parse_#{attr}")
        recipe.__send__("#{attr}=", value)
      end
      recipe
    end

    def parse_author
      # is it always first?
      recipe_doc.css(itemprop_node_for(:author)).first.content
    end

    def parse_name
      # is it always first?
      recipe_doc.css(itemprop_node_for(:name)).first.content
    end

    def parse_prep_time
      # is it always first?
      # leverage iso8601
      recipe_doc.css(itemprop_node_for(:prepTime)).first["datetime"]
    end

    def recipe_attributes
      self.class.recipe_attributes
    end

    def recipe_doc
      @recipe_doc ||= doc.css(self.class.root_doc)
    end

  end

  class NullObject
    def method_missing(*args, &block)
      nil
    end
  end

end
end

