class Node < Hash
  def initialize(name, attributes = [], parent = nil)
    super()
    self[:name] = name
    self[:attributes] = attributes
    self[:children] = []
    @parent = parent
  end

  def parent
    @parent
  end

  def add_child(name, attributes = [])
    child = Node.new(name, attributes, self)
    self[:children] << child
    child
  end

  def add_sibling(name, attributes = [])
    raise "Cannot add sibling to root node" if root?

    parent.add_child(name, attributes)
  end

  def children?
    self[:children].any?
  end

  def root?
    parent.nil?
  end
end
