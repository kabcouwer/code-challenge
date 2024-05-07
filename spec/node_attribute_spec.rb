require "./lib/node_attribute"

RSpec.describe NodeAttribute do
  let(:name) { "lang" }
  let(:value) { "en" }
  subject(:attribute) { described_class.new(name, value) }

  describe "#initialize" do
    it "creates an instance of NodeAttribute" do
      expect(attribute).to be_an_instance_of(described_class)
      expect(attribute.name).to eq(name)
      expect(attribute.value).to eq(value)
    end
  end
end