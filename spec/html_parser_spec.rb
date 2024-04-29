require "json"
require "./lib/html_parser"

RSpec.describe HtmlParser do
  let(:html_file_path) { "./files/van-gogh-paintings.html" }
  let(:expected_output) do
    JSON.parse(File.read("./files/expected-array.json"))
  end

  subject { described_class.new(html_file_path) }

  describe "#call" do
    it "returns the expected output" do
      html_parser = subject.call

      require 'pry'; binding.pry

      expect(html_parser.keys).to include("artworks")

      artworks = html_parser["artworks"]

      expect(artworks).to be_an(Array)
      expect(artworks).not_to be_empty
      expect(artworks.first.keys).to include("name", "extensions", "link") # needs image key
      # expect(html_parser).to output(JSON.pretty_generate(expected_output)).to_stdout
    end
  end
end
