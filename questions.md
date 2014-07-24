What is best practice for testing Nokogiri (unit test?
integration test?)
  - since Im using fixtures, whats the best way to load them into the
test? is there a helper to get to the fixutres directory?
  - is fixtures a rails specific thing?

What is the RSpec 3 equivalent of:
  subject { Object.new }
  its(:attribute) { should eq(5) }

