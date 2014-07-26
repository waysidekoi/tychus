describe Tychus::Parsers::FoodNetworkParser do
  subject { Tychus::Parsers::FoodNetworkParser.new(food_network_uri) }

  context "When the page has a single ingredients group" do
    # NOTE: this specific uri has an author who's hidden in an anchor
    # tag that also references her TV show and episode the recipe
    # appeared. #parse_author may be complex for this edge case
    # NOTE: author is formatted using schema.org/Person
    let(:food_network_uri) { File.expand_path("../../fixtures/food_network_single_ingredients_group.html", __FILE__) }
    let(:ingredients) {
      [
        "Good olive oil",
        "1 teaspoon minced garlic",
        "1/2 teaspoon Dijon mustard",
        "2 tablespoons champagne vinegar",
        "Kosher salt and freshly ground black pepper",
        "1/2 hothouse cucumber, unpeeled, seeded and sliced 1/2-inch thick",
        "1 large ripe tomato, cut into 1-inch cubes",
        "10 large basil leaves",
        "3 tablespoons capers, drained",
        "1 red onion, sliced into 1/4 inch rounds",
        "1 red bell pepper, seeded and cut into 3 large pieces",
        "1 yellow bell pepper, seeded and cut into 3 large pieces",
        "1/2 small ficelle, cut into 1-inch thick slices"
      ]
    }
    let(:instructions) {
      [
        "Prepare a charcoal grill with hot coals. Brush the grilling rack with olive oil.",
        "In a small bowl, whisk together the garlic, mustard, vinegar, 1/4 cup olive oil, 1/2 teaspoon salt and 1/4 teaspoon pepper. Set aside.",
        "Place the cucumber, tomato, basil and capers in a large bowl, sprinkle with salt and pepper and toss together. Set aside.",
        "When the grill is ready, brush 1 side of the onion slices and the peppers with olive oil. Place them, olive oil side down, on the grill and cook for 4 minutes. Brush the other side with olive oil, turn them over and continue cooking an additional 4 minutes. Remove the vegetables from the grill and place on a cutting board. Slice the peppers 1/2-inch thick, separate the onion rings and add them both to the cucumber mixture.",
        "Brush the bread slices on both sides with olive oil and toast them on the grill until golden. Add them to the cucumber mixture. Pour the reserved vinaigrette over the vegetables and toss together. Serve warm."
      ]
    }

    it "parses the name of the recipe" do
      expect(subject.parse_name).to eq("Grilled Panzanella")
    end

    it "parses the author" do
      expect(subject.parse_author).to eq("Ina Garten")
    end

    it "parses the prep time" do
      expect(subject.parse_prep_time).to eq("PT0H25M")
    end

    it "parses the cook time" do
      expect(subject.parse_cook_time).to eq("PT0H20M")
    end

    it "parses the total time" do
      expect(subject.parse_total_time).to eq("PT0H45M")
    end

    it "parses the yield" do
      expect(subject.parse_recipe_yield).to eq("6 servings")
    end

    it "parses the ingredients" do
      expect(subject.parse_ingredients).to eq(ingredients)
    end

    it "parses the instructions" do
      expect(subject.parse_recipe_instructions).to eq(instructions)
    end

    xit "parses the image" do
      # currently two item properties with "image" exist:
      # one of which comes from a microformat for Person, which
      # references the author, and is the image of the author,
      # and another which is the correct image
      #
      # Cannot just remove the microformat for Person, like we do for
      # VideoObject and for Review, because in this case, the Person
      # microformat contains the author name which must not be deleted
      # before parsing
    end

    it "parses the description" do
      expect(subject.parse_description).to eq("Get this all-star, easy-to-follow Grilled Panzanella recipe from Ina Garten.")
    end

  end

end
