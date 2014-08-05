describe Tychus::ParserSelector do
  subject(:parser_selector) { Tychus::ParserSelector }

  context "allrecipes.com uris" do
    before {
      VCR.use_cassette(cassette) do
        @m = Tychus::MetaParser.new(uri).parse
      end
    }
    let(:uri) { "http://allrecipes.com/Recipe/Chicken-Pot-Pie-IX/Detail.aspx?soid=recs_recipe_2" }
    let(:cassette) { "parser_selector_allrecipes_1" }

    specify "resolve to the AllrecipesParser" do
      expect(subject.resolve_parser(@m)).to eq(Tychus::Parsers::AllrecipesParser)
    end

  end

  context "when specific parser doesn't exist but uri uses schema org's microformat" do
    before do
      VCR.use_cassette(cassette) do
        @m = Tychus::MetaParser.new(uri).parse
      end
    end

    context "for 'cookingquinoa.net'" do

      let(:uri) { "http://www.cookingquinoa.net/quinoa-bacon-club-wrap/" }
      let(:cassette) { "cooking_quinoa" }

      it "resolves to the Schema Org Parser" do
        expect(subject.resolve_parser(@m)).to eq(Tychus::Parsers::SchemaOrgParser)
      end
    end

    context "for 'asideofsweet.com'" do

      let(:uri) { "http://asideofsweet.com/black-cherry-buttermilk-ice-cream/" }
      let(:cassette) { "a_side_of_sweet" }

      it "resolves to the Schema Org Parser" do
        expect(subject.resolve_parser(@m)).to eq(Tychus::Parsers::SchemaOrgParser)
      end
    end

  end

end

