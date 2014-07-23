describe Tychus::ParserSelector do
  subject(:parser_selector) { Tychus::ParserSelector.new(uri) }

  context "allrecipes.com uris" do
    let(:uri) { "http://allrecipes.com/Recipe/Chicken-Pot-Pie-IX/Detail.aspx?soid=recs_recipe_2" }

    it "resolves to the AllrecipesParser" do
      expect(subject.resolve_parser).to eq(Tychus::Parsers::AllrecipesParser)
    end

  end

end

