describe Tychus::Parsers::AllrecipesParser do
  subject { Tychus.parse(allrecipes_uri) }
  # 7/26/14 source:
  # http://allrecipes.com/Recipe/Chicken-Pot-Pie-IX/Detail.aspx?soid=recs_recipe_2
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
  let(:instructions) {
    [
      "Preheat oven to 425 degrees F (220 degrees C.)",
      "In a saucepan, combine chicken, carrots, peas, and celery. Add water to cover and boil for 15 minutes. Remove from heat, drain and set aside.",
      "In the saucepan over medium heat, cook onions in butter until soft and translucent. Stir in flour, salt, pepper, and celery seed. Slowly stir in chicken broth and milk. Simmer over medium-low heat until thick. Remove from heat and set aside.",
      "Place the chicken mixture in bottom pie crust. Pour hot liquid mixture over. Cover with top crust, seal edges, and cut away excess dough. Make several small slits in the top to allow steam to escape.",
      "Bake in the preheated oven for 30 to 35 minutes, or until pastry is golden brown and filling is bubbly. Cool for 10 minutes before serving."
    ]
  }

  its(:name) { is_expected.to eq("Chicken Pot Pie IX") }
  its(:author) { is_expected.to eq("Robbie Rice") }
  its(:prep_time) { is_expected.to eq("PT20M") }
  its(:cook_time) { is_expected.to eq("PT50M") }
  its(:total_time) { is_expected.to eq("PT1H10M") }
  its(:yield) { is_expected.to eq("1 - 9 inch pie") }
  its(:ingredients) { is_expected.to eq(ingredients) }
  its(:instructions) { is_expected.to eq(instructions) }
  its(:image) { is_expected.to eq("http://images.media-allrecipes.com/userphotos/250x250/00/14/23/142350.jpg") }
  its(:description) { is_expected.to eq("\"A delicious chicken pie made from scratch with carrots, peas and celery.\"") }
end

