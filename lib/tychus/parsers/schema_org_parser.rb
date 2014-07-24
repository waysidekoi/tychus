module Tychus
module Parsers

  class SchemaOrgParser < Base

    def self.root_doc
      '[itemtype="http://schema.org/Recipe"]'
    end

    def itemprop_node_for(property)
      "[itemprop='#{property}']"
    end

  end

end
end

