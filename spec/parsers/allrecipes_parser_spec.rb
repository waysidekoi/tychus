describe Tychus::Parsers::AllrecipesParser do
  # self.class?
  subject { Tychus.parse(allrecipes_uri) }
  let(:allrecipes_uri) { File.expand_path("../../fixtures/allrecipes.html", __FILE__) }
  let(:ingredients) {
    [
      "1 pound skinless, boneless chicken breast halves - cubed",
      "1 cup sliced carrots",
      "1 cup frozen green peas",
      "1/2 cup sliced celery",
      "1/3 cup butter",
      "1/3 cup chopped onion",
      "1/3 cup all-purpose flour",
      "1/2 teaspoon salt",
      "1/4 teaspoon black pepper",
      "1/4 teaspoon celery seed",
      "1 3/4 cups chicken broth",
      "2/3 cup milk",
      "2 (9 inch) unbaked pie crusts"
    ]
  }

  its(:name) { is_expected.to eq("Chicken Pot Pie IX") }
  its(:author) { is_expected.to eq("Robbie Rice") }
  its(:prep_time) { is_expected.to eq("PT20M") }
  its(:cook_time) { is_expected.to eq("PT50M") }
  its(:total_time) { is_expected.to eq("PT1H10M") }
  its(:yield) { is_expected.to eq("1 - 9 inch pie") }
  its(:recipe_yield) { is_expected.to eq("1 - 9 inch pie") }
  its(:ingredients) { is_expected.to eq(ingredients) }
end

