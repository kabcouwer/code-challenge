require "./lib/node_attribute"

RSpec.describe NodeAttribute do
  let(:name) { "lang" }
  let(:value) { "en" }
  subject(:attribute) { described_class.new(name, value) }

  describe "#initialize" do
    it "creates an instance of NodeAttribute" do
      expect(attribute).to be_an_instance_of(described_class)
      expect(attribute).to be_a(Hash)
      expect(attribute[:name]).to eq(name)
      expect(attribute[:value]).to eq(value)
    end
  end

  describe "#name" do
    it "returns the name of the attribute" do
      expect(attribute.name).to eq(name)
    end
  end

  describe "#value" do
    it "returns the value of the attribute" do
      expect(attribute.value).to eq(value)
    end
  end
end