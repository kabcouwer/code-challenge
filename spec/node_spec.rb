require "./lib/node_attribute"
require "./lib/node"

RSpec.describe Node do
  let(:name) { "html" }
  let(:attribute_one) { NodeAttribute.new("root", "true") }
  let(:attribute_two) { NodeAttribute.new("parent", "true") }
  let(:attributes) { [attribute_one, attribute_two] }

  subject(:root_node) { described_class.new(name, attributes) }

  describe "#initialize" do
    it "creates an instance of Node" do
      expect(root_node).to be_an_instance_of(described_class)
    end

    it "is a Hash" do
      expect(root_node).to be_a(Hash)
    end

    it "has a name" do
      expect(root_node[:name]).to eq(name)
      expect(name).to be_a(String)
    end

    it "has attributes" do
      expect(root_node[:attributes]).to eq(attributes)
      expect(attributes).to be_an_instance_of(Array)
      expect(attributes.first).to be_an_instance_of(NodeAttribute)
    end

    it "has children" do
      expect(root_node[:children]).to eq([])
    end

    it "has a parent" do
      expect(root_node[:parent]).to be_nil
    end
  end

  describe "#parent" do
    it "returns the parent node" do
      child = root_node.add_child("head")

      expect(child.parent).to eq(root_node)
    end

    it "is immutable" do
      child = root_node.add_child("head")

      expect { child.parent = nil }.to raise_error(NoMethodError)
      
      expect(child.parent).to eq(root_node)
    end
  end


  describe "#add_child" do
    let(:child_name) { "head" }
    let(:child_attribute) { NodeAttribute.new("child", "") }
    let(:child_attributes) { [child_attribute] }

    it "adds a child node to the current node" do
      child = root_node.add_child(child_name, child_attributes)
      expect(child[:name]).to eq(child_name)
      expect(child[:attributes]).to eq(child_attributes)
      expect(child[:children]).to eq([])
      expect(child.parent).to eq(root_node)
      expect(root_node[:children]).to include(child)
    end

    it "returns the child node" do
      child = root_node.add_child(child_name, child_attributes)
      expect(child).to be_an_instance_of(described_class)
    end
  end

  describe "#add_sibling" do
    let(:node) { root_node.add_child("head") }
    let(:sibling_name) { "body" }
    let(:sibling_attribute) { NodeAttribute.new("sibling", "true") }
    let(:sibling_attributes) { [sibling_attribute] }

    it "adds a sibling node to the current node" do
      sibling = node.add_sibling(sibling_name, sibling_attributes)
      expect(sibling[:name]).to eq(sibling_name)
      expect(sibling[:attributes]).to eq(sibling_attributes)
      expect(sibling[:children]).to eq([])
      expect(sibling.parent).to eq(node.parent)
      expect(node.parent[:children]).to include(sibling)
    end

    it "returns the sibling node" do
      sibling = node.add_sibling(sibling_name, sibling_attributes)
      expect(sibling).to be_an_instance_of(described_class)
    end

    it "raises an error if the node is the root node" do
      expect { root_node.add_sibling(sibling_name, sibling_attributes) }
        .to raise_error("Cannot add sibling to root node")
    end
  end

  describe "#children?" do
    it "returns false if the node has no children" do
      expect(root_node.children?).to be(false)
    end

    it "returns true if the node has children" do
      root_node.add_child("head")
      expect(root_node.children?).to be(true)
    end
  end

  describe "#root?" do
    it "returns true if the node is the root node" do
      expect(root_node.root?).to be(true)
    end

    it "returns false if the node is not the root node" do
      node = root_node.add_child("head")
      expect(node.root?).to be(false)
    end
  end
end