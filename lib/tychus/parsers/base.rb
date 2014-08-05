require 'active_support/core_ext/object/blank.rb'

module Tychus
module Parsers

  class Base
    attr_reader :uri, :doc, :recipe_doc, :recipe

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
        description
        prep_time
        cook_time
        total_time
        recipe_yield
        ingredients
        recipe_instructions
        image
      ]
    end

    def initialize(uri)
      @uri = uri
      @recipe = Recipe.new
      @doc = Nokogiri::HTML(open(uri))
      @recipe_doc = root_doc ? @doc.css(root_doc) : @doc
    end

    def clean_instructions(obj)
      obj
    end

    def parse
      recipe_attributes.each do |attr|
        property_value = __send__("parse_#{attr}")
        recipe.__send__("#{attr}=", Value(property_value))
      end
      recipe
    end

    def recipe_attributes
      self.class.recipe_attributes
    end

    def root_doc
      nil
    end

    def Value(obj)
      case obj
      when NullObject then nil
      else obj
      end
    end
  end

  class NullObject
    def method_missing(*args, &block)
      self
    end
  end

end
end
