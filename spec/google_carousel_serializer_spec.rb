require "json"
require "./lib/node_attribute"
require "./lib/node"
require "./lib/html_doc"
require "./lib/google_carousel_serializer"

RSpec.describe GoogleCarouselSerializer do
  let(:html_file_path) { "./files/van-gogh-paintings.html" }
  let(:expected_output) do
    JSON.parse(File.read("./files/expected-array.json"))
  end

  subject { described_class.new(html_file_path) }

  describe "#call" do
    it "returns the expected output" do
      html = File.read(html_file_path)
      serializer = described_class.new(html)
      result = serializer.call

      expect(result.keys).to include("data")

      data = result["data"]

      expect(data).to be_an(Array)
      expect(data).not_to be_empty
      expect(data.first.keys).to include("name", "extensions", "link") # needs image key
    end
  end
end
