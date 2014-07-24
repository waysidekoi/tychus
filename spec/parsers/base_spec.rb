describe Tychus::Parsers::Base do
  let(:bogus_uri) { "http://bogus.uri" }
  subject { Tychus::Parsers::Base.new(bogus_uri) }

  context "initialization" do

    it "instantiates a recipe object with the recipe attributes" do
      subject.class.recipe_attributes.each do |attr|
        expect(subject.recipe).to respond_to(attr)
      end
    end

  end

  describe "#parse" do

  end
end

