module Tychus
module Parsers
  # going to look for an 'ingredient' class and retrieve elements
  class ::Array
    def concatenate_last(content)
      # add space unless content begins with a period
      last = self.pop || ""
      if content.match(/(\.|,).*/)
        self.push "#{last}#{content}"
      else
        self.push "#{last} #{content}"
      end
    end
  end

  class SimpleParser < Base

    def self.strategies
      %i[ :ingredient_class_search
      ]
    end

    def class_search
      ingredients = doc.css('.ingredient')
      ingredients.map do |node|
        node.content
          .squeeze(" ")
          .rstrip
          .lstrip
          .split("\r\n")
      end.flatten
    end

    def clean(str)
      # gsub &nbsp; and strip
      # TODO: strip special characters from beginning, for ex- bullets
      str.gsub(/[[:space:]]/,' ')
        .gsub(/•/,'')
        .lstrip
        .rstrip
        .squeeze(" ")
    end


    def ingredients_block?(el)
      # arbitrary content size to assume content which is not
      # a 'ul' (for now, and most likely a 'p'), of longer than average
      # length, should indicate a paragraph of text for the directions,
      # and therefore ineligible
      ingredients_end_regex = /\A(instructions|preparation|directions|process).?\s*\z/i

      !clean(el.content).match(ingredients_end_regex)
    end

    def nested_a_node?(node)
      node.children.size < 5 && node.children.map(&:name).include?("a")
    end

    def nested_tr_node?(node)
      node.name == "tr"
    end

    def nested_tr_content(node)
      node.element_children.map(&:content).join(" ")
    end

    def nested_li_node?(node)
      #TODO: do we need to verify if children > 1?
      node.children.size > 1 && node.name == "li"
    end

    def nested_p_node?(node)
      node.name == "p" && node.element_children.present?
    end

    def nested_p_content(node)
      # concatenate all content from nodes to the previous element and only
      # create a new element only when following a "br". 
      # This assume "br" will determine when the _actual_ line breaks are
      # specifically for situations where it beings as text, then follows with
      # an anchor tag, and then follows with more text.
      node.children.inject([]) do |ingredients, sub_node|
        ingredients.concatenate_last(sub_node.content) unless sub_node.content.blank?
        ingredients.push("") if sub_node.name == "br" || sub_node.children.map(&:name).include?("br")
        ingredients
      end
    end

    def monolith_ingredients_element_parse
      ingredients = []

      while el && ingredients_block?(el)
        ingredients.concatenate_last(el.content) unless el.content.blank?
        ingredients.push("") if el.name == "br" || el.children.map(&:name).include?("br")
        ingredients

        el = el.next_sibling
      end

      ingredients.reject(&:blank?).map{|x| clean(x)}
    end

    def paragraph_ingredients_element_parse
      ingredients = []

      # TODO: make the retrieval stop if it detects it's reached a non-ingredient
      # block, most likely the directions/instructions/process/preparation block
      while el && ingredients_block?(el)
        ingredients << retrieve_nested_text(el)
        el = el.next_sibling
      end

      # re: #take_while => Assume directions come in a block, so we can strip any following
      # elements once we think we've reached one 'direction' element
      ingredients.flatten
        .reject(&:blank?)
        .map {|x| clean(x) }
        .take_while{|x| valid_ingredient?(x)}
    end

    def retrieve_nested_text(node)
      return node.content if node.text? || nested_a_node?(node) || nested_li_node?(node)
      return nested_tr_content(node) if nested_tr_node?(node)
      return nested_p_content(node) if nested_p_node?(node)
      # assume beginning of directions/preparations block
      return if node.name == "p" && node.element_children.blank? && node.content.size > 150
      node.children.map do |sub_node|
        retrieve_nested_text(sub_node)
      end
    end

    def root_node(node, content)
      # root node is the highest node where the content matches the node's content

      return node if clean(node.parent.content) != clean(content)
      root_node(node.parent, content)
    end

    def text_search
      els = doc.search("[text()*='Ingredients']").presence || doc.search("[text()*='INGREDIENTS']")
      return unless els.any?
      ingredient_node = root_node(els.first, els.first.content)

      # assume root node is choosing the actual root child element of the parent, and not a nested child
      # then root_node.parent should have many children. In this scenario, the ingredients should live in
      # the siblings, and the first ingredient should reside directly after the root_node
      el = ingredient_node.next_sibling

      # iterate until you reach a node with text 'Directions'
      #   ? should we validate ingredients here? We can make an assumption
      #     that the ingredient will (most of the time) will begin with a
      #     measurement. How to handle when it doesnt? 1 database lookup worth it to validate
      #     ingredients that don't being with an integer?
    end

    def valid_ingredient?(ingredient)
      # TODO: discern directions correctly
      ingredient.length < 150 || ingredient.match(/\A\d+/)
    end
  end

end
end
