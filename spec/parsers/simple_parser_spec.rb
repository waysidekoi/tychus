describe Tychus::Parsers::SimpleParser do

  describe "#class_search" do

    specify "retrieves ingredients when they reside within nested span elements with an 'ingredient' class" do
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
        expect(Tychus::Parsers::SimpleParser.new(url).class_search).to eq(ingredients)
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

  describe "'Ingredients' text search strategy" do

    context "when text, 'Ingredients' exists" do

      context "and the ingredients reside _within_ the same element as the 'Ingredients' tag" do
        it "retrieves ingredients when they reside as text, not within specific tags" do

          url = "http://www.chardincharge.com/2014/08/coffee-101-morning-buzz-smoothie.html"
          ingredients = [
            "6 oz. cold brewed coffee",
            "1/4 cup cold coconut milk (scoop the fat that settles at the top)",
            "1/2 teaspoon vanilla extract",
            "1 ripe banana",
            "2 medjool dates or 1/2 tablespoon raw honey",
            "1/4 cup rolled oats",
            "1 tablespoon flax seeds",
            "4 coffee ice cubes, optional"
          ]

          VCR.use_cassette("chardincharge.com") do
            # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
            # italic/parenthetical annotations in the ingredient
            expect(Tychus::Parsers::SimpleParser.new(url).monolith_ingredients_element_parse).to eq(ingredients)
          end

        end

        it "retrieves ingredients when they reside as text, not within specific tags #2" do

          url = "http://veryculinary.com/2014/08/11/vegetarian-breakfast-sandwich/"
          ingredients = [
            "4 Morningstar sausage patties",
            "4 eggs",
            "1 1/2 tablespoons freshly grated Parmesan",
            "1 tablespoon milk",
            "1 scallion, finely diced",
            "1 tablespoon unsalted butter",
            "4 thin slices (about 4 ounces) Havarti cheese",
            "2 cooked biscuits or rolls, split in half"
          ]

          VCR.use_cassette("veryculinary.com") do
            # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
            # italic/parenthetical annotations in the ingredient
            expect(Tychus::Parsers::SimpleParser.new(url).monolith_ingredients_element_parse).to eq(ingredients)
          end

        end

        it "retrieves ingredients when they reside as text, not within specific tags #3" do
          url = "http://www.kalynskitchen.com/2008/08/vegan-tomato-salad-recipe-with-cucumber.html"
          ingredients = [
            "6 medium tomatoes, diced into bite-sized pieces (about 2 cups diced tomatoes)",
            "2 medium cucumbers, diced into bite-sized pieces (about 1 cup diced cucumber)",
            "1 or 2 avocados, diced into bite-sized pieces",
            "1 T fresh squeezed lime juice (to toss with avocado)",
            "Vege-Sal or salt to taste (for seasoning avocado)",
            "1 cup chopped cilantro (use more or less to taste; use thinly sliced green onion if you're not a cilantro fan)",
            "Dressing Ingredients:",
            "2 T fresh squeezed lime juice",
            "1 T best quality extra virgin olive oil",
            "1/4 tsp. Spike seasoning (optional, but good; can use another all-purpose seasoning blend if you don't have Spike)",
            "salt to taste (I used Vege-Sal, but sea salt would be great here)"
          ]

          VCR.use_cassette("kalynskitchen.com") do
            # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
            # italic/parenthetical annotations in the ingredient
            expect(Tychus::Parsers::SimpleParser.new(url).monolith_ingredients_element_parse).to eq(ingredients)
          end
        end
      end

      context "and the ingredients reside _after_ the 'Ingredients' tag" do

        context " and reside within a table" do
          it "retrieves the ingredients when they reside as td elements within multiple tr elements" do
            url = "http://keepyourdietreal.com/food/breakfastbrunch/loaded-breakfast-baked-potatoes/"
            ingredients = [
              "2 medium Russet potatoes, scrubbed",
              "1 T Olive oil",
              "1/4 t each Sea salt and black pepper",
              "4 large Eggs",
              "1/4 cup Milk, 1%",
              "4 T Salsa",
              "1/2 cup Shredded cheddar cheese, 2%",
              "1/4 cup Avocado, peeled and diced",
              "1/4 cup Raw veggie toppings*"
            ]

            VCR.use_cassette("keepyourdietreal.com") do
              # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
              # italic/parenthetical annotations in the ingredient
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end
        end

        context " and reside within one or more ul elements" do

          it "retrieves the ingredients when they reside as text within li elements" do
            url = "http://www.recipris.com/2014/08/05/tofu-black-bean-tacos/"
            ingredients = [
              "cooking oil",
              "olive oil spray",
              "12 oz. firm tofu, strained and cubed",
              "1 15 oz. can black beans, strained and rinsed",
              "1 ½ tsp. taco seasoning",
              "white corn tortillas (I used La Tortilla Factory Hand Made Style Corn Tortillas and they truly tasted hand made / not mass produced!!)",
              "pickled red onions",
              "fresh cilantro",
              "fresh jalapeños (if you like it spicy)",
              "canned tame jalapeños in juice" ,
              "½ cup yogurt",
              "lime (to make the plate look pretty and festive!)"
            ]

            VCR.use_cassette("recipris.com") do
              # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
              # italic/parenthetical annotations in the ingredient
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end

          it "retrieves the ingredients when they reside as text within li elements #2" do
            pending "The directions section is unlabeled, and therefore cannot be discerned from ingredients"
            url = "http://cocoawind.blogspot.com/2014/05/eggless-chocolate-brownie-fudgy-eggless.html"
            ingredients = [
              "Flour - 3/4 Cup",
              "Sugar - 1/2 Cup",
              "Baking Powder - 1 tsp",
              "Baking Soda - 1/4 tsp",
              "Salt - 1/8 tsp or a fat pinch",
              "Chocolate Chip - 1 1/2 Cups (I prefer Ghirardelli Semi-Sweet Chocolate Chips)",
              "Butter - 3 tbsp, unsalted",
              "Applesauce - 1/2 Cup",
              "Vanilla Extract - 1/2 tsp",
              "Instant Coffee Granules- 1/2 tsp",
              "Hot Water - 2 tbsp"
            ]

            VCR.use_cassette("cocoawind.com") do
              # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
              # italic/parenthetical annotations in the ingredient
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end

          it "retrieves the ingredients when they reside as text within li elements #3" do
            url = "http://www.afarmgirlsdabbles.com/2014/08/11/end-of-summer-herby-chicken-chili-pot-recipe/"
            ingredients = [
              "4 T. Land O Lakes® Butter with Canola Oil, divided",
              "1 lb. of chicken breasts, lightly sprinkled on both sides with kosher salt and freshly ground black pepper",
              "1 large yellow onion, chopped into 1/2\" pieces",
              "1 large red bell pepper, chopped into 1/2\" pieces",
              "4 large garlic cloves, minced",
              "1 tsp. minced fresh jalapeno pepper",
              "1 zucchini, chopped into 1/2\" pieces",
              "1 yellow squash, chopped into 1/2\" pieces",
              "corn kernels cut from 4 large ears of fresh sweet corn (do not cook the corn)",
              "2 14.5-oz. cans diced fire roasted tomatoes (do not drain)",
              "12 oz. beer or chicken broth",
              "2 T. cumin",
              "1 T. chili powder",
              "1 tsp. sweet smoked paprika",
              "juice and zest from 1 lime",
              "1 c. chopped fresh herbs of your choice (I used 1/3 cup parsley, 1/3 cup dill, 1/3 cup basil)",
              "optional goodies to offer alongside:",
              "shredded smoked gouda cheese",
              "chopped fresh cilantro",
              "chopped green onions",
              "sour cream",
              "fresh lime wedges, for squeezing over the chili",
              "fresh baked Honey Cornbread Muffins, with additional Land O Lakes® Butter with Canola Oil"
            ]

            VCR.use_cassette("afarmgirlsdabbles.com") do
              # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
              # italic/parenthetical annotations in the ingredient
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end

          it "retrieves the ingredients when they reside as text within li elements #4" do
            url = "http://somethingnewfordinner.com/recipe/cherry-panna-cotta/"
            ingredients = [
              "2 T water",
              "1 1/2 t unflavored gelatin",
              "1 1/2 T vanilla bean paste, divided",
              "2 cups whipping cream",
              "1 1/4 cup plain greek yogurt",
              "1/2 cup sugar",
              "2 cups fresh pitted cherries",
              "1/8 to 1/4 cup sugar, depending on the sweetness of your cherries",
              "4\" x 1\" strip of lemon zest",
              "1T lemon juice",
              "1/4 cup water",
              "6 sprigs of mint for garnish"
            ]

            VCR.use_cassette("something_new_for_dinner.com") do
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end

          it "retrieves the ingredients when they reside within <span> elements within li elements" do
            url = "http://colorfuleatsnutrition.com/recipes/grain-gluten-and-refined-sugar-free-lilikoi-cheesecake-with-macadamia-nut-crust"
            ingredients = [
              "Grain Free Macadamia Nut Crust",
              "1 cup macadamia nuts",
              "1/2 cup cashews",
              "1 cup shredded coconut",
              "3 tbsp raw honey",
              "3 tbsp coconut oil",
              "Lilikoi Cheesecake Filling",
              "8 oz cream cheese, room temperature",
              "1/2 cup sour cream",
              "3/4 cup full fat coconut milk, separated",
              "1/4 cup raw honey",
              "1/4 cup fresh lilikoi juice, seeds removed",
              "1 tbsp gelatin, grass-fed preferably",
              "Garnish",
              "8 oz heavy whipping cream",
              "1/4 cup shredded coconut flakes, lightly toasted"
            ]

            VCR.use_cassette("colorfuleatsnutrition.com") do
              # this actually works with paragraph_ingredients_element_parse, with the exception of the pesky
              # italic/parenthetical annotations in the ingredient
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end
        end

        context " and reside within ONE p element" do

          it "retrieves the ingredients when they reside as text, and not within specific tags" do
            url = "http://www.merrygourmet.com/2014/08/strawberry-cookies/"
            ingredients = [
              "3 cups (375 grams) all-purpose flour",
              "1 teaspoon baking powder",
              "1/2 teaspoon kosher salt",
              "1-1/2 cup (300 grams) granulated sugar",
              "4 ounces (1 stick; 113 grams) unsalted butter, room temperature",
              "2 large eggs",
              "3/4 cup strawberry puree (from 2 cups strawberries)",
              "1/2 teaspoon vanilla extract",
              "Red food coloring (optional) (I use AmeriColor Soft Gel food coloring.)",
              "1/2 cup confectioners sugar"
            ]

            VCR.use_cassette("merrygourment.com") do
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end

          it "retrieves the ingredients when they reside as text, and not within specific tags #2" do
            url = "http://www.wellnesting.com/blog1/2014/8/10/detox-smoothie"
            ingredients = [
              "1 ½ c frozen blue berries",
              "1 c dandelion greens",
              "1 small beet and greens",
              "1 piece kombu or other seaweed",
              "1 c hemp milk",
              "¼ cup coconut cream"
            ]

            VCR.use_cassette("well_nesting.com") do
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end

          it "retrieves the ingredients when they reside in <span> tags within one p element" do

            url = "http://notacurry.com/eggplant-cooked-yogurt-sauce/"
            ingredients = [
              "1 large eggplant, cut into 1 inch cubes",
              "1/2 tsp sugar",
              "1/2 tsp turmeric powder",
              "1/2 tsp salt",
              "2 tbsp oil",
              "1 cup yogurt",
              "1 cup water",
              "1 tbsp ginger paste",
              "1 green chili, chopped",
              "1 tsp cumin powder",
              "1 tsp coriander powder",
              "1/2 tsp red chili powder",
              "1 tbsp sugar",
              "salt to taste",
              "1/4 cup raisins",
              "cilantro and/or mint leaves for garnish"
            ]

            VCR.use_cassette("notacurry.com") do
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end

          end
        end

        context " and reside within TWO p elements" do

          it "retrives the ingredients when they reside in two consecutive p elements after the 'Ingredients' element" do
            url = "http://dailyburn.com/life/recipes/pork-tenderloin-mango-salsa-habanero-recipe/"
            ingredients = [
              "For the salsa:",
              "1/3 cup cubed mango",
              "1 medium yellow tomato, chopped",
              "1/4 cup chopped red onion",
              "2 tablespoons chopped cilantro leaves",
              "2 teaspoons white vinegar",
              "2 teaspoons fresh lime juice",
              "2 teaspoons water",
              "1/2 teaspoon vegetable oil",
              "1/4 – 1/2 habanero pepper, seeded",
              "For the pork:",
              "2 (1 pound) boneless pork tenderloin roasts",
              "4 garlic cloves, minced",
              "1/4 cup olive oil",
              "1 teaspoon kosher salt",
              "1 teaspoon freshly ground black pepper"
            ]

            VCR.use_cassette("dailyburn.com") do
              expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
            end
          end

        end

        it "retrieves the ingredients when they reside in multiple <div> elements" do
          url = "http://www.confessionsofafoodie.me/2014/08/how-to-roast-chicken.html#.U-qJ__6zDx1"
          ingredients = [
            "For the compound butter:",
            "3 tablespoons butter, room temperature",
            "1 ½ teaspoons sea salt",
            "¼ teaspoon ground cumin",
            "½ teaspoon freshly grated black pepper",
            "1 ½ tablespoons finely chopped fresh rosemary",
            "1 clove garlic, minced",
            "Zest from one medium lemon",
            "For the grapes:",
            "1 ½ pounds Muscato grapes (or any seedless red grape)",
            "2 tablespoons extra virgin olive oil",
            "1 tablespoon balsamic vinegar",
            "½ teaspoon sea salt",
            "1 ½ tablespoons fresh mint, finely chopped",
            "4 ½ - 5 lb chicken",
            "1 lemon",
            "2 sprigs fresh rosemary"
          ]

          VCR.use_cassette("confessionsofafoodie.me") do
            expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
          end
        end

        it "retrieves the ingredients when they reside in multiple h3 elements" do
          url = "http://brazilianflairintheusa.com/raspberry-yogurt-cake/"
          ingredients = [
            "For the raspberry yogurt cake:",
            "10 1/2 oz. all-purpose flour",
            "2 tsp. baking powder",
            "pinch of salt",
            "4 1/2 oz. butter, cut into pieces",
            "8 oz. superfine sugar",
            "finely grated zest of 2 lemons",
            "1/2 tsp. vanilla extract",
            "2 eggs, room temperature, lightly beaten",
            "4 oz. plain yogurt",
            "7 oz. fresh raspberries",
            "For the icing:",
            "5 1/2 oz. powdered sugar",
            "2 T. lemon juice",
            "8-10 raspberries",
          ]

          VCR.use_cassette("brazilian_flair_in_the_usa.com") do
            expect(Tychus::Parsers::SimpleParser.new(url).paragraph_ingredients_element_parse).to eq(ingredients)
          end
        end

      end

    end

    context "when text, 'Ingredients' does not exist" do

      xit "returns nil" do
        url = "http://www.eatcakefordinner.net/2014/08/sunrise-poppy-seed-muffins-with-orange.html"

        VCR.use_cassette("ingredients_text_does_not_exist") do
          expect(Tychus::Parsers::SimpleParser.new(url).text_search).to be_nil
        end
      end

    end

  end

end
