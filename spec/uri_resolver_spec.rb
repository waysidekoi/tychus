# at this point intime, allrecipes/campbellskitchen/kraftrecipes all contain both schema.org/recipe canonical uri elements as
# well as open graph canonical uri elements
#
describe Tychus::URIResolver do

  context "when schema.org and opengraph canonical uri properties exist" do
    let(:allrecipes_uri) { 'http://allrecipes.com/Recipe/Chicken-Pot-Pie-IX/Detail.aspx' }
    let(:kraft_recipes_uri) { "http://www.kraftrecipes.com/recipes/sweet-bbq-chicken-kabobs-92092.aspx" }
    let(:examples) { [
      [allrecipes_uri, 'allrecipes.com', 'allrecipes_1'],
      [kraft_recipes_uri, 'kraftrecipes.com', 'kraft_recipes_1']
    ]}

    it "retrieves the host" do
      examples.each do |html|
        page = html[0]
        host = Regexp.new(html[1])

        VCR.use_cassette(html[2]) do
          expect(Tychus::URIResolver.new(page).resolve_uri.host).to match_regex(host)
        end

      end
    end

  end

  context "when only opengraph canonical uri properties exist" do
    let(:campbells_kitchen_uri) { "http://www.campbellskitchen.com/recipes/squash-casserole-24122" }
    let(:examples) {
      [
        [campbells_kitchen_uri, 'campbellskitchen.com', 'campbells_kitchen_1']
      ]
    }

    it "is missing a schema org microformat" do
      examples.each do |html|
        page = html[0]
        cassette = html[2]

        VCR.use_cassette(cassette) do
          node = Nokogiri::HTML(open(page))
          expect(node.css('[itemprop="http://schema.org/Recipe"]')).to be_empty
        end
      end
    end

    it "retrieves the host" do
      examples.each do |html|
        page = html[0]
        host = Regexp.new(html[1])
        cassette = html[2]

        VCR.use_cassette(cassette) do
          expect(Tychus::URIResolver.new(page).resolve_uri.host).to match_regex(host)
        end
      end

    end
  end

end

