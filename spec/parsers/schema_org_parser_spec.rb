describe Tychus::Parsers::SchemaOrgParser do
  context "on creation" do
    let(:allrecipes_uri) { 'http://allrecipes.com/Recipe/Chicken-Pot-Pie-IX/Detail.aspx' }
    let(:parser) do
      VCR.use_cassette("allrecipes_1") do
        Tychus::Parsers::AllrecipesParser.new(allrecipes_uri)
      end
    end

    it "strips the Review microformat from node to prevent name collisions with item properties of different microformats" do
      expect(parser.recipe_doc.css(parser.review_doc)).to be_empty
    end

    it "strips the videoObject microformat from node to prevent name collisions with item properties of different microformats" do
      expect(parser.recipe_doc.css(parser.video_object_doc)).to be_empty
    end

    pending "find a non schema org recipe to test that it does not attempt to call #strip_review_microformat"
  end
end

