require_relative 'parsers/base'
require_relative 'parsers/schema_org_parser'
require_relative 'parsers/open_graph_protocol_parser'
require_relative 'parsers/allrecipes_parser'
require_relative 'parsers/food_network_parser'
require_relative 'parsers/kraft_recipes_parser'
require_relative 'parsers/campbells_kitchen_parser'
require_relative 'parsers/ingredients_text_parser'

module Tychus
module Parsers

  Recipe = Struct.new(*Base.recipe_attributes) do
    alias_method :yield, :recipe_yield
    alias_method :instructions, :recipe_instructions
  end

end
end

