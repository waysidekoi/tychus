module Tychus
module Parsers

  class KraftRecipesParser < SchemaOrgParser

    def self.uri_host
      "kraftrecipes.com"
    end

    def parse_description
      # description can be found in .recipeDesc or meta tag in header
      # TODO: pull out meta tag parsing into own methods/class?
      doc.css('meta[name="description"]').first.attr('content')
    end

    def parse_name
      # "\r\n\tSweet BBQ Chicken Kabobs\r\n\t"
      result = super
      result.gsub(/(\r|\n|\t)/,'')
    end

    def parse_recipe_instructions
      itemprop_node_for(:recipeInstructions)
        .element_children
        .map do|x|
          x.content
            .squeeze(" ")
            .rstrip
            .split("\r\n\t")
            .map{|x|x.gsub(/\t/,'')}
        end.flatten.reject(&:blank?)
    end

    def parse_ingredients
      # NOT FIRST
      # "1 lb.\r\n\t\t\t\t\t\t\t\t boneless skinless chicken breasts, cut into 1-1/2-inch pieces", "2 cups\r\n\t\t\t\t\t\t\t\t fresh pineapple chunks (1-1/2 inch)", "1 \r\n\t\t\t\t\t\t\t\t each red and green pepper, cut into 1-1/2-inch pieces", "1/2 cup\r\n\t\t\t\t\t\t\t\t KRAFT Original Barbecue Sauce", "3 Tbsp.\r\n\t\t\t\t\t\t\t\t frozen orange juice concentrate, thawed"
      recipe_doc
        .css('[itemprop="ingredients"]')
        .map do|ingredient_node|
          ingredient_node
            .element_children
            .map do |node| node.content
              .lstrip
              .rstrip
              .squeeze(" ")
              .gsub(/(\r|\n|\t)/,'')
            end.join(" ")
        end.reject(&:blank?)
    end

  end

end
end

