require_relative 'parsers/base'
require_relative 'parsers/schema_org_parser'
require_relative 'parsers/allrecipes_parser'

module Tychus
module Parsers

  Recipe = Struct.new(*Base.recipe_attributes) do
    alias_method :yield, :recipe_yield
  end

end
end

