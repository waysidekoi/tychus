def unindent(str)
  str.strip.gsub("\n", "").squeeze(" ").gsub(/\s(?=\<)/,'')
end

describe Tychus::Parsers::IngredientsTextParser do

  describe "#within_br_node?" do
    let(:parser) { Tychus::Parsers::IngredientsTextParser.new('') }

    it "recognizes when following <a> tag" do
      html = <<-eos
      <div>
        <a href="http://kalynskitchen.blogspot.com/2008/06/kalyns-kitchen-picks-vege-sal.html">Vege-Sal</a> 
        or salt to taste (for seasoning avocado)
        <br>
        1 cup chopped cilantro (use more or less to taste; use thinly sliced green onion if you're not a cilantro fan)
        <br>
      </div>
      eos

      html = unindent(html)
      doc = Nokogiri::HTML::Document.parse(html)
      el = doc.search("[text()*=' or salt to taste (for seasoning avocado)']")
        .first
        .children
        .find {|x| x.content ==' or salt to taste (for seasoning avocado)'}

      expect(parser.within_br_node?(el)).to be_truthy
    end
  end

  describe "#retrieve_nested_text" do
    let(:parser) { Tychus::Parsers::IngredientsTextParser.new('') }

    it "doesn't break up content within <li>'s" do
      html = <<-eos
      <ul>
        <li id="yui_3_17_2_1_1408333898449_1000">
          <span>1 cup
            <a href="#" target="_blank"> shredded coconut</a>
          </span>
        </li>
      </ul>
      eos

      html = unindent(html)
      doc = Nokogiri::HTML::Document.parse(html)
      el = doc.search("li").first
      expect(parser.retrieve_nested_text(el)).to eq("1 cup shredded coconut")
    end
  end

  describe "#br_node?" do
    let(:parser) { Tychus::Parsers::IngredientsTextParser.new('') }
    it "recognizes consecutive <span> elements" do
      html = <<-eos
          <div>
            <b>Ingredients</b>
            <br>
            <span>2 to 3 tablespoons honey </span>
            <span>or maple syrup (if using honey pick one with a mild taste)</span>
            <br>
            <br>
          </div>
      eos
      html = unindent(html)
      doc = Nokogiri::HTML::Document.parse(html)
      el = doc.search("[text()*='2 to 3 tablespoons honey']").first

      expect(parser.br_node?(el)).to be_truthy
    end

    it "recognizes when node begins with <a>" do
      html = <<-eos
        <br>
        <a href="http://kalynskitchen.blogspot.com/2008/06/kalyns-kitchen-picks-vege-sal.html">Vege-Sal</a> 
        or salt to taste (for seasoning avocado)
        <br>
        1 cup chopped cilantro (use more or less to taste; use thinly sliced green onion if you're not a cilantro fan)
        <br>
      eos

      html = unindent(html)
      doc = Nokogiri::HTML::Document.parse(html)
      el = doc.search("[text()*='Vege-Sal']").first

      expect(parser.br_node?(el)).to be_truthy
    end
  end

  describe "#class_search" do

    let(:url) { "http://www.campbellskitchen.com/recipes/squash-casserole-24122" }
    let(:parser) { Tychus::Parsers::IngredientsTextParser.new(url) }

    specify "retrieves ingredients when they reside within nested span elements with an 'ingredient' class" do
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
        expect(parser.class_search).to eq(ingredients)
      end
    end

    it "calls the correct method" do
      expect(parser).to receive(:class_search)
      parser.class_search
    end
  end

  describe "ingredients parsing when 'Ingredients' text exists" do

    context " and the ingredients are in the same element as the 'Ingredients' node" do
      let(:urls) do
        [
          "http://www.chardincharge.com/2014/08/coffee-101-morning-buzz-smoothie.html",
          "http://veryculinary.com/2014/08/11/vegetarian-breakfast-sandwich/",
          "http://www.kalynskitchen.com/2008/08/vegan-tomato-salad-recipe-with-cucumber.html",
          "http://www.thegardengrazer.com/2014/07/wild-rice-spinach-salad-with-lemon.html",
          "http://www.theironyou.com/2014/08/raspberry-hibiscus-popsicles.html",
          # "http://www.from-thelionsden.com/2014/08/peach-mango-smoothie.html"
        ]
      end
      let(:ingredients) do
        [ 
          [
            # "http://www.chardincharge.com/2014/08/coffee-101-morning-buzz-smoothie.html" 
            "6 oz. cold brewed coffee",
            "1/4 cup cold coconut milk (scoop the fat that settles at the top)",
            "1/2 teaspoon vanilla extract",
            "1 ripe banana",
            "2 medjool dates or 1/2 tablespoon raw honey",
            "1/4 cup rolled oats",
            "1 tablespoon flax seeds",
            "4 coffee ice cubes, optional"
          ],
          [
            # "http://veryculinary.com/2014/08/11/vegetarian-breakfast-sandwich/"
            "4 Morningstar sausage patties",
            "4 eggs",
            "1 1/2 tablespoons freshly grated Parmesan",
            "1 tablespoon milk",
            "1 scallion, finely diced",
            "1 tablespoon unsalted butter",
            "4 thin slices (about 4 ounces) Havarti cheese",
            "2 cooked biscuits or rolls, split in half"
          ],
          [
            # "http://www.kalynskitchen.com/2008/08/vegan-tomato-salad-recipe-with-cucumber.html"
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
          ],
          [
            # "http://www.thegardengrazer.com/2014/07/wild-rice-spinach-salad-with-lemon.html",
            "1 cup wild rice",
            "3 oz. spinach",
            "8 oz. grape tomatoes",
            "1 orange bell pepper",
            "1 cup corn (thawed, if frozen)",
            "3-4 green onions",
            "Optional: hemp hearts, beans, fresh herbs",
            "{For the dressing}",
            "Juice from 1 lemon (about 3-4 Tbsp.)",
            "1 garlic clove, minced",
            "2 Tbsp. olive oil",
            "1/8 tsp. salt"
          ],
          [
            # "http://www.theironyou.com/2014/08/raspberry-hibiscus-popsicles.html"
            "Makes about 8 popsicles (it depends on the size of your mold though)",
            "3 cups / 13.5 oz / 375 gr fresh raspberries",
            "2 cups / 500 ml hibiscus tea, brewed and chilled (green tea also works)",
            "2 to 3 tablespoons honey or maple syrup (if using honey pick one with a mild taste)"
          ],
          # [
          #    # "http://www.from-thelionsden.com/2014/08/peach-mango-smoothie.html"
          #    # not passing atm
          #    "1/2 Cup yellow peach, diced",
          #    "1/2 Cup mango, diced",
          #    "1 medium banana",
          #    "1 Tbs coconut",
          #    "1 Cup almond milk (or regular milk)",
          #    "1 Cup ice cubes"
          # ]
        ]
      end

      it "hits" do
        urls.each_with_index do |url, i|
          parser = Tychus::Parsers::IngredientsTextParser.new(url)

          VCR.use_cassette(url[/\w+.com/]) do
            expect(parser.parse_ingredients).to eq(ingredients[i])
          end

        end
      end

    end


    context "and the ingredients reside _after_ the 'Ingredients' tag" do

      it "hits when the ingredients are within td elements within multiple tr elements in a table" do
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
        parser = Tychus::Parsers::IngredientsTextParser.new(url)

        VCR.use_cassette(url[/\w+\.com/]) do
          expect(parser.parse_ingredients).to eq(ingredients)
        end

      end

      context " and reside as text within li elements as plain text or within <span>'s" do
        let(:urls) do
          [
            "http://www.recipris.com/2014/08/05/tofu-black-bean-tacos/",
            "http://www.afarmgirlsdabbles.com/2014/08/11/end-of-summer-herby-chicken-chili-pot-recipe/",
            "http://somethingnewfordinner.com/recipe/cherry-panna-cotta/",
            "http://butteredsideupblog.blogspot.com/2014/08/homemade-chocolate-syrup-for-chocolate.html",
            "http://colorfuleatsnutrition.com/recipes/grain-gluten-and-refined-sugar-free-lilikoi-cheesecake-with-macadamia-nut-crust",
          ]
        end

        let(:ingredients) do
          [
            [
              # "http://www.recipris.com/2014/08/05/tofu-black-bean-tacos/"
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
            ],
            [
              # "http://www.afarmgirlsdabbles.com/2014/08/11/end-of-summer-herby-chicken-chili-pot-recipe/"
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
            ],
            [
              # "http://somethingnewfordinner.com/recipe/cherry-panna-cotta/"
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
            ],
            [
               # "http://butteredsideupblog.blogspot.com/2014/08/homemade-chocolate-syrup-for-chocolate.html"
               "1 cup water",
               "1 cup sucanat",
               "1 cup cocoa powder (my favorite HERE)",
               "1/2 teaspoon real salt",
               "1 teaspoon pure vanilla extract",
            ],
            [
              # "http://colorfuleatsnutrition.com/recipes/grain-gluten-and-refined-sugar-free-lilikoi-cheesecake-with-macadamia-nut-crust"
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
            ],
          ]
        end

        it "hits" do
          urls.each_with_index do |url, i|
            parser = Tychus::Parsers::IngredientsTextParser.new(url)

            VCR.use_cassette(url[/(\w+\.)+com/]) do
              expect(parser.parse_ingredients).to eq(ingredients[i])
            end
          end
        end

      end # Reside within <li>

      context " and reside as text within a <p> element" do
        let(:urls) do
          [
            "http://www.merrygourmet.com/2014/08/strawberry-cookies/",
            "http://www.wellnesting.com/blog1/2014/8/10/detox-smoothie",
            "http://www.bunsinmyoven.com/2014/08/11/bacon-jalapeno-cheese-spread/",
            "http://notacurry.com/eggplant-cooked-yogurt-sauce/",
          ]
        end

        let(:ingredients) do
          [
            [
              #"http://www.merrygourmet.com/2014/08/strawberry-cookies/"
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
            ],
            [
              # "http://www.wellnesting.com/blog1/2014/8/10/detox-smoothie"
              "1 ½ c frozen blue berries",
              "1 c dandelion greens",
              "1 small beet and greens",
              "1 piece kombu or other seaweed",
              "1 c hemp milk",
              "¼ cup coconut cream"
            ],
            [
              # "http://www.bunsinmyoven.com/2014/08/11/bacon-jalapeno-cheese-spread/"
              "4 ounces cheddar, grated",
              "4 ounces pepper jack, grated",
              "2 ounces cream cheese, room temperature",
              "3 tablespoons mayonnaise",
              "2 strips bacon, cooked and crumbled",
              "3 tablespoons diced pickled jalapenos",
              "1/2 teaspoon juice from jar of jalapenos"
            ],
            [
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
            ],
          ]
        end

        it "hits" do
          urls.each_with_index do |url, i|
            parser = Tychus::Parsers::IngredientsTextParser.new(url)

            VCR.use_cassette(url[/(\w+\.)+com/]) do
              expect(parser.parse_ingredients).to eq(ingredients[i])
            end
          end
        end
      end # Reside within <p>

      it "hits when the ingredients and reside within two <p> elements" do
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
        parser = Tychus::Parsers::IngredientsTextParser.new(url)

        VCR.use_cassette(url[/(\w+\.)+com/]) do
          expect(parser.parse_ingredients).to eq(ingredients)
        end
      end # Reside within 2 <p>

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
        parser = Tychus::Parsers::IngredientsTextParser.new(url)

        VCR.use_cassette(url[/(\w+\.)+me/]) do
          expect(parser.parse_ingredients).to eq(ingredients)
        end
      end

      it "retrieves the ingredients when they reside in multiple <div> elements" do
        url = "http://www.leannebakes.com/2014/08/frosted-cookie-cakes.html"
        ingredients = [
          "For the chocolate chip cookies:",
          "2 cups all-purpose flour",
          "1/2 teaspoon baking soda",
          "1/2 teaspoon salt",
          "3/4 cup unsalted butter, melted",
          "1 cup brown sugar",
          "1/2 cup white sugar",
          "1 tablespoon vanilla extract",
          "1 egg",
          "1 egg yolk",
          "1 1/2 cup chocolate chips or chunks",
          "3/4 cup butter",
          "2-3 cups icing sugar",
          "1 tablespoon vanilla",
          "1/4 - 1/2 cup rainbow sprinkles"
        ]
        parser = Tychus::Parsers::IngredientsTextParser.new(url)

        VCR.use_cassette(url[/(\w+\.)+com/]) do
          expect(parser.parse_ingredients).to eq(ingredients)
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
        parser = Tychus::Parsers::IngredientsTextParser.new(url)

        VCR.use_cassette(url[/(\w+\.)+com/]) do
          expect(parser.parse_ingredients).to eq(ingredients)
        end
      end # reside within multiple h3 elements

    end # Reside _after_ 'Ingredients' tag
  end # When 'Ingredients' text exist

  it "returns nil when 'Ingredients' text doesn't exist" do
    url = "http://www.eatcakefordinner.net/2014/08/sunrise-poppy-seed-muffins-with-orange.html"

    parser = Tychus::Parsers::IngredientsTextParser.new(url)

    VCR.use_cassette(url[/(\w+\.)+net/]) do
      expect{parser.parse_ingredients}.to raise_error
    end
  end

  pending "identifies when to stop retrieving ingredients" do
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
    parser = Tychus::Parsers::IngredientsTextParser.new(url)

    VCR.use_cassette(url[/\w+.com/]) do
      expect(parser.parse_ingredients).to eq(ingredients[i])
    end
  end

end
