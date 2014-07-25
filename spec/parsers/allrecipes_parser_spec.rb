describe Tychus::Parsers::AllrecipesParser do
  # self.class?
  subject { Tychus.parse(allrecipes_uri) }
  let(:allrecipes_uri) { File.expand_path("../../fixtures/allrecipes.html", __FILE__) }

  its(:name) { is_expected.to eq("Chicken Pot Pie IX") }
  its(:author) { is_expected.to eq("Robbie Rice") }
  its(:prep_time) { is_expected.to eq("PT20M") }
end

