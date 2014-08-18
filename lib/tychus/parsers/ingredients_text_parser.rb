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

  class IngredientsTextParser < Base

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
      # if this node is the beginning of a br_node block, check its inner contents
      # otherwise, go by its #contents
      ingredients_end_regex = /\A(instructions|preparation|directions|process).?\s*\z/i

      return false if br_node?(el) && clean(nested_br_content(el).first).match(ingredients_end_regex)
      !clean(el.content).match(ingredients_end_regex)
    end

    def nested_br_content(node)
      results = []
      while node && !node.name.match(/\A(br)\z/)
        results.concatenate_last(node.content)
        node = node.next_sibling
      end
      results
    end

    def within_br_node?(node)
      return false unless previous_sibling(node)
      previous_sibling(node).name != "br" &&
        next_siblings(node, 3).any?{ |x| x.name == "br" }
    end

    def br_node?(node)
      previous_sibling(node) &&
        previous_sibling(node).name == "br" &&
        next_siblings(node, 3).any? {|x| x.name == "br" }
    end

    def nested_tr_node?(node)
      node.name == "tr"
    end

    def nested_tr_content(node)
      node.element_children.map(&:content).join(" ")
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

    def retrieve_nested_text(node)
      #order matters
      return if within_br_node?(node)
      return nested_br_content(node) if br_node?(node)
      return node.content if node.text? || node.name == "li"
      return nested_tr_content(node) if node.name == "tr"
      return nested_p_content(node) if nested_p_node?(node)

      node.children.map do |sub_node|
        retrieve_nested_text(sub_node)
      end
    end

    def root_node(node, content)
      # root node is the highest node where the content matches the node's content

      return node if clean(node.parent.content) != clean(content)
      root_node(node.parent, content)
    end

    def ingredient_node
      # assume root node is choosing the actual root child element of the parent, and not a nested child
      # then root_node.parent should have many children. In this scenario, the ingredients should live in
      # the siblings, and the first ingredient should reside directly after the root_node

      els = doc.search("[text()*='Ingredients']").presence || doc.search("[text()*='INGREDIENTS']")
      return nil unless els.any?
      root_node(els.first, els.first.content).next_sibling
    end

    def parse_ingredients
      raise "No parser found" unless ingredient_node

      # iterate until you reach a node with text 'Directions'
      #   ? should we validate ingredients here? We can make an assumption
      #     that the ingredient will (most of the time) will begin with a
      #     measurement. How to handle when it doesnt? 1 database lookup worth it to validate
      #     ingredients that don't being with an integer?

      ingredients = []
      el = ingredient_node

      # TODO: make the retrieval stop if it detects it's reached a non-ingredient
      # block, most likely the directions/instructions/process/preparation block
      while el && ingredients_block?(el)
        ingredients << retrieve_nested_text(el)
        el = el.next_sibling
      end


      ingredients.flatten
        .reject(&:blank?)
        .map {|x| clean(x) }
        .take_while{|x| valid_ingredient?(x)}
    end

    def previous_sibling(node)
      previous_siblings(node, 1).last
    end

    def previous_siblings(node, count=nil)
      node_index = node.parent.children.index(node)
      from = count ? node_index - count : 0
      value = node.parent.children.select.with_index { |child, i| i >= from && i < node_index }
    end

    def next_siblings(node, count=nil, incl_self=false)
      node_index = node.parent.children.index(node)
      to = count ? node_index + count : node.parent.children.size
      node.parent.children.select.with_index { |child, i| i >= node_index && i <= to }
    end

    def valid_ingredient?(ingredient)
      # TODO: discern directions correctly
      ingredient.length < 150 || ingredient.match(/\A\d+/)
    end
  end

end
end
