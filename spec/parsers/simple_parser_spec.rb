describe Tychus::Parsers::SimpleParser do
  let(:non_schema_urls) {
    [
      {
        url: "http://www.campbellskitchen.com/recipes/squash-casserole-24122",
        cassette: "campbells_kitchen_1",
        ingredients: [
         "3 cups Pepperidge Farm® Cornbread Stuffing",
         "1/4 cup butter, melted (1/2 stick)",
         "1 can (10 3/4 ounces) Campbell's® Condensed Cream of Chicken Soup (Regular or 98% Fat Free)",
         "1/2 cup sour cream",
         "2 small yellow squash, shredded (about 2 cups)",
         "2 small zucchini, shredded (about 2 cups)",
         "1 small carrot, shredded (about 1/3 cup)",
         "1/2 cup shredded Cheddar cheese (about 2 ounces)"
        ]
      },
      {
        url: "http://asideofsweet.com/black-cherry-buttermilk-ice-cream/",
        cassette: "a_side_of_sweet",
        ingredients: [
        ]
      }
    ]
  }

  describe "#ingredient_class_search" do

    it "retrieves the ingredients correctly" do
      non_schema_urls.each do |url_hash|
        VCR.use_cassette(url_hash[:cassette]) do
          expect(Tychus::Parsers::SimpleParser.new(url_hash[:url]).ingredient_class_search).to eq(url_hash[:ingredients])
        end
      end
    end

  end

end
