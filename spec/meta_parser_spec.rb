describe Tychus::MetaParser do
  subject do
    VCR.use_cassette("meta_parser_#{uri}") do
      Tychus::MetaParser.new(__send__(uri)).parse
    end
  end

  shared_examples_for "a_parsable_uri" do
    its(:uri_object) { is_expected.to be_present }
    its(:uri) { is_expected.to be_present }
    its(:host) { is_expected.to be_present }
  end

  context "when uri uses fb:og protocol" do
    let(:uri) { "og_protocol_uri" }
    let(:og_protocol_uri) { "http://www.campbellskitchen.com/recipes/squash-casserole-24122" }

    it_behaves_like "a_parsable_uri"

    its(:schema_org_microformat?) { is_expected.to be_falsy }
    its(:open_graph_protocol) { is_expected.to be_present }
    its(:open_graph_protocol?) { is_expected.to be_truthy }
  end

  context "when uri uses schema.org microformat" do
    let(:uri) { "schema_org_microformat_uri" }
    let(:schema_org_microformat_uri) { "http://allrecipes.com/Recipe/Chicken-Pot-Pie-IX/Detail.aspx?soid=recs_recipe_2" }

    it_behaves_like "a_parsable_uri"

    its(:schema_org_microformat?) { is_expected.to be_truthy }
    its(:open_graph_protocol) { is_expected.to be_nil }
    its(:open_graph_protocol?) { is_expected.to be_falsy }
  end
end

