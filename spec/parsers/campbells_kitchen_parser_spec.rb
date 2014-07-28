describe Tychus::Parsers::CampbellsKitchenParser do
  before { pending "Does NOT use schema.org microformat" }
  subject do
    VCR.use_cassette("campbells_kitchen_1") do
      Tychus::Parsers::CampbellsKitchenParser.new(campbells_kitchen_uri)
    end
  end

  let(:campbells_kitchen_uri) { "http://www.campbellskitchen.com/recipes/squash-casserole-24122" }
  let(:ingredients) {
    [
       "3 cups Pepperidge Farm® Cornbread Stuffing",
       "1/4 cup butter, melted (1/2 stick)",
       "1 can (10 3/4 ounces) Campbell's® Condensed Cream of Chicken Soup (Regular or 98% Fat Free)",
       "1/2 cup sour cream",
       "2 small yellow squash, shredded (about 2 cups)",
       "2 small zucchini, shredded (about 2 cups)",
       "1 small carrot, shredded (about 1/3 cup)",
       "1/2 cup shredded Cheddar cheese (about 2 ounces)"
    ]
  }

  let(:instructions) {
    [
       "Stir the stuffing and butter in a large bowl. Reserve 1/2 cup of the stuffing mixture and spoon the remaining stuffing mixture into a 2-quart shallow baking dish.",
       "Stir the soup, sour cream, yellow squash, zucchini, carrot and cheese in a medium bowl. Spread the mixture over the stuffing mixture and sprinkle with the reserved stuffing mixture.",
       "Bake at 350°F. for 40 minutes or until the mixture is hot and bubbling."
    ]
  }

  it "parses the name of the recipe" do
    expect(subject.parse_name).to eq("Squash Casserole")
  end

  it "parses the author" do
    expect(subject.parse_author).to eq(nil)
  end

  it "parses the prep time" do
    expect(subject.parse_prep_time).to eq("PT15M")
  end

  it "parses the cook time" do
    expect(subject.parse_cook_time).to eq("PT40M")
  end

  it "parses the total time" do
    expect(subject.parse_total_time).to eq("PT55M")
  end

  it "parses the yield" do
    expect(subject.parse_recipe_yield).to eq("8")
  end

  it "parses the image" do
    expect(subject.parse_image).to eq("http://www.campbellskitchen.com/recipeimages/squash-casserole-large-24122.jpg")
  end

  it "parses the ingredients" do
    expect(subject.parse_ingredients).to eq(ingredients)
  end

  it "parses the instructions" do
    expect(subject.parse_recipe_instructions).to eq(instructions)
  end

  it "parses the description" do
    expect(subject.parse_description).to eq("This creamy, crowd-pleasing side dish features summer squash, carrots, stuffing mix and cheese baked in a creamy sauce. Crispy on top and creamy in the center, it's a winner on any menu.")
  end
end

