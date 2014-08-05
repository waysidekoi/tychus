module Tychus
module Parsers
  # going to look for an 'ingredient' class and retrieve elements
  class SimpleParser < Base
    def self.strategies
      %i[ :ingredient_class_search
      ]
    end

    def ingredient_class_search
      ingredients = doc.css('.ingredient')
      ingredients.map do |node|
        node.content
          .squeeze(" ")
          .rstrip
          .lstrip
          .split("\r\n")
      end.flatten
    end


  end
end
end

