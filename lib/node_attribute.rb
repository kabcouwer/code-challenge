class NodeAttribute < Hash
  def initialize(name, value)
    super()
    self[:name] = name
    self[:value] = value
  end

  def name
    self[:name]
  end

  def value
    self[:value]
  end
end
