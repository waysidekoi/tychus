# at this point intime, allrecipes/campbellskitchen/kraftrecipes
# fixtures all contain both schema.org/recipe canonical uri elements as
# well as open graph canonical uri elements
#
describe Tychus::URIResolver do
  context "when schema.org and opengraph canonical uri properties exist" do
    let(:allrecipes_uri) { File.expand_path("../fixtures/allrecipes.html", __FILE__) }
    let(:campbells_kitchen_uri) { File.expand_path("../fixtures/campbellskitchen.html", __FILE__) }
    let(:kraft_recipes_uri) { File.expand_path("../fixtures/kraftrecipes.html", __FILE__) }
    let(:examples) { [
      [allrecipes_uri, 'allrecipes.com'],
      [campbells_kitchen_uri, 'campbellskitchen.com'],
      [kraft_recipes_uri, 'kraftrecipes.com']
    ]}

    it "able to retrieve it" do
      examples.each do |html|
        page = html[0]
        host = Regexp.new(html[1])
        expect(Tychus::URIResolver.new(page).resolve_uri).to match_regex(host)
      end
    end
  end
end

