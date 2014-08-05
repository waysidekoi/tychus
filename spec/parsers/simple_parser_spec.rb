describe Tychus::Parsers::SimpleParser do

  describe "#ingredient_class_search" do

    specify "simple case" do
        url = "http://www.campbellskitchen.com/recipes/squash-casserole-24122"
        ingredients = [
           "3 cups Pepperidge Farm® Cornbread Stuffing",
           "1/4 cup butter, melted (1/2 stick)",
           "1 can (10 3/4 ounces) Campbell's® Condensed Cream of Chicken Soup (Regular or 98% Fat Free)",
           "1/2 cup sour cream",
           "2 small yellow squash, shredded (about 2 cups)",
           "2 small zucchini, shredded (about 2 cups)",
           "1 small carrot, shredded (about 1/3 cup)",
           "1/2 cup shredded Cheddar cheese (about 2 ounces)"
        ]

      VCR.use_cassette("campbells_kitchen_1") do
        expect(Tychus::Parsers::SimpleParser.new(url).ingredient_class_search).to eq(ingredients)
      end
    end

    specify "non-descriptive paragraph element within multi-level div nesting" do
      url = "http://abetterhappierstsebastian.com/journal/2014/8/4/chickpea-veggie-burger-with-fried-halloumi"
      ingredients = [
        "2 whole wheat buns",
        "1 15 oz can garbanzo beans, drained",
        "6 oz porchini mushrooms, diced",
        "1/2 red pepper, diced",
        "1/2 cup cut kale leaves (about 3 stems)",
        "2 thick slices halloumi cheese",
        "1 egg",
        "1/4 cup breadcrumbs",
        "1 1/2 tbs chickpea flour",
        "4 tsp olive oil, divided",
        "1 tsp cumin",
        "3 tsp garlic powder",
        "salt and pepper"
      ]

      VCR.use_cassette("a_better_happier_st_sebastian") do
        expect(Tychus::Parsers::SimpleParser.new(url).ingredient_class_search).to eq(ingredients)
      end
    end

    specify "non-descript list of divs " do
      url = "http://www.confessionsofafoodie.me/2014/08/how-to-roast-chicken.html#.U9-_OKPZUxE"
      ingredients = [
        "3 tablespoons butter, room temperature",
        "1 ½ teaspoons sea salt",
        "¼ teaspoon ground cumin",
        "½ teaspoon freshly grated black pepper",
        "1 ½ tablespoons finely chopped fresh rosemary",
        "1 clove garlic, minced",
        "Zest from one medium lemon",
        "1 ½ pounds muscato grapes (or any seedless red grape)",
        "2 tablespoons extra virgin olive oil",
        "1 tablespoon balsamic vinegar",
        "½ teaspoon sea salt",
        "1 ½ tablespoons fresh mint, finely chopped",
        "4 ½ - 5 lb chicken",
        "1 lemon",
        "2 sprigs fresh rosemary"
      ]
    end

  end

end
