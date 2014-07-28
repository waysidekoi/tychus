describe Tychus::Parsers::KraftRecipesParser do
  def null_object
    Tychus::Parsers::NullObject
  end

  subject { Tychus::Parsers::KraftRecipesParser.new(kraft_recipes_uri) }

  let(:kraft_recipes_uri) { File.expand_path("../../fixtures/kraftrecipes.html", __FILE__) }

  let(:ingredients) {
    [
      "1 lb. boneless skinless chicken breasts, cut into 1-1/2-inch pieces",
      "2 cups fresh pineapple chunks (1-1/2 inch)",
      #NOTE: This is an escaped whitespace I'm punting on
      "1 each red and green pepper, cut into 1-1/2-inch pieces",
      "1/2 cup KRAFT Original Barbecue Sauce",
      "3 Tbsp. frozen orange juice concentrate, thawed"
    ]
  }

  let(:instructions) {
    [
      "HEAT grill to medium-high heat.",
      "THREAD chicken alternately with pineapple and peppers onto 8 long wooden skewers, using 2 skewers placed side-by-side for each kabob.",
      "MIX barbecue sauce and juice concentrate; brush half evenly onto kabobs.",
      "GRILL 8 to 10 min. or until chicken is done, turning and brushing occasionally with remaining sauce."
    ]
  }

  it "parses the name of the recipe" do
    expect(subject.parse_name).to eq("Sweet BBQ Chicken Kabobs")
  end

  it "parses the author" do
    expect(subject.parse_author).to be_a null_object
  end

  it "parses the prep time" do
    expect(subject.parse_prep_time).to eq("PT25M")
  end

  it "parses the cook time" do
    expect(subject.parse_cook_time).to be_a null_object
  end

  it "parses the total time" do
    expect(subject.parse_total_time).to eq("PT25M")
  end

  it "parses the yield" do
    expect(subject.parse_recipe_yield).to eq("4 servings")
  end

  xit "parses the ingredients (bug with escaped backspace that cant be stripped)" do
    expect(subject.parse_ingredients).to eq(ingredients)
  end

  it "parses the instructions" do
    expect(subject.parse_recipe_instructions).to eq(instructions)
  end

  it "parses the description" do
    expect(subject.parse_description).to eq("These better-for-you BBQ chicken kabobs have an island vibe going on. Think OJ, fresh pineapple and peppers. Now all you need is a drink with an umbrella.")
  end

end

