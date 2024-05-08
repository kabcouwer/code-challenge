require "./lib/node_attribute"
require "./lib/node"
require "./lib/html_doc"

RSpec.describe HTMLDoc do
  # let(:html_file_path) { "./files/test-fixture.html" }
  let(:html_file_path) { "./files/van-gogh-paintings.html" }
  let(:html) { File.read(html_file_path) }
  let(:doc) { described_class.new(html) }

  describe "#initialize" do
    it "creates a new HTMLDoc object" do
      expect(doc).to be_a(HTMLDoc)
    end

    it "creates a root node" do
      expect(doc.root).to be_a(Node)
    end

    it "parses the html" do
      expect(doc.root[:name]).to eq("document")
    end

    it "creates the correct structure" do
      expect(doc.root[:children].size).to eq(1)
      expect(doc.root[:children].first[:name]).to eq("html")

      html_node = doc.root[:children].first

      expect(html_node[:children].size).to eq(3)
      expect(html_node[:children].first[:name]).to eq("head")
      expect(html_node[:children].last[:name]).to eq("body")
    end
  end

  describe "#css" do
    context "when selector is found" do
      it "returns the node" do
        node = doc.css("klitem")

        expect(node).to be_an(Array)
        expect(node.size).to eq(51)
      end
    end
  end

  describe "#closing_tag?" do
    context "when element is closing tag" do
      it "returns true" do
        expect(doc.send(:closing_tag?, "</html>")).to be(true)
      end

      it "returns false" do
        expect(doc.send(:closing_tag?, "<html>")).to be(false)
      end
    end
  end

  describe "#opening_tag?" do
    context "when element is opening tag" do
      it "returns true" do
        expect(doc.send(:opening_tag?, "<html>")).to be(true)
      end

      it "returns true" do
        expect(doc.send(:opening_tag?, "</html>")).to be(true)
      end

      it "returns false" do
        expect(doc.send(:opening_tag?, "html")).to be(false)
      end
    end
  end

  describe "#tag_name" do
    context "when element is opening tag" do
      let(:element) { "<title>" }

      it "returns the name of the node" do
        name = doc.send(:tag_name, element)

        expect(name).to eq("title")
      end
    end

    context "when element is opening tag with attributes" do
      let(:element) { "<html itemscope=\"\" itemtype=\"http://schema.org/SearchResultsPage\" lang=\"en\">" }

      it "returns the name of the node" do
        name = doc.send(:tag_name, element)

        expect(name).to eq("html")
      end
    end
  end

  describe "#tag_attributes" do
    context "when element is opening tag" do
      let(:element) { "<html>" }

      it "returns an array of node attributes" do
        attributes = doc.send(:tag_attributes, element)

        expect(attributes).to be_a(Array)
        expect(attributes.size).to eq(0)
      end
    end

    context "when element is opening tag with attributes" do
      let(:element) { "<html itemscope=\"\" itemtype=\"http://schema.org/SearchResultsPage\" lang=\"en\">" }

      it "returns an array of node attributes" do
        attributes = doc.send(:tag_attributes, element)

        expect(attributes).to be_a(Array)
        expect(attributes.size).to eq(3)
      end

      it "returns the correct node attributes" do
        attributes = doc.send(:tag_attributes, element)

        expect(attributes.map(&:name)).to eq(["itemscope", "itemtype", "lang"])
        expect(attributes.map(&:value)).to eq(["", "http://schema.org/SearchResultsPage", "en"])
      end
    end
  end
end