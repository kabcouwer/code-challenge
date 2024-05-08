class Node < Hash
  def initialize(name, node_attributes = [], parent = nil)
    super()
    self[:name] = name
    self[:node_attributes] = node_attributes
    self[:children] = []
    @parent = parent
  end

  def parent
    @parent
  end

  def add_child(name, node_attributes = [])
    child = Node.new(name, node_attributes, self)
    self[:children] << child
    child
  end

  def add_sibling(name, node_attributes = [])
    raise "Cannot add sibling to root node" if root?

    parent.add_child(name, node_attributes)
  end

  def children?
    self[:children].any?
  end

  def root?
    parent.nil?
  end

  def get_value_from_attribute(name)
    self[:node_attributes].find { |attr| attr.name == name }&.value
  end

  private

  def find_css_recursively(node, selector, result = [])
    if node.is_a?(String)
      return
    elsif node[:node_attributes].any? { |attr| attr.name == "class" && attr.value == selector }
      result << node
    end
  
    node[:children].each do |child|
      find_css_recursively(child, selector, result)
    end
  
    result
  end
end
