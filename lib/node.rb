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
end
