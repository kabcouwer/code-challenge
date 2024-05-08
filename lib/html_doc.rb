class HTMLDoc < Node
  attr_reader :root, :current_node, :html

  def initialize(html)
    @html = html
    @root = parse_html
  end

  def parse_html
    html_elements(html).each do |element|
      if root.nil?
        @root = Node.new("document")
        @current_node = root
      elsif closing_tag?(element)
        go_to_parent
      elsif opening_tag?(element)
        handle_opening_tag(element)
      else
        handle_text_content(element)
      end
    end
    root
  end

  def css(selector)
    find_css_recursively(root, selector)
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

  def html_elements(html)
    elements = []

    while match = html.match(/<[^>]+>|[^<]+/)
      tag = match[0]
      elements << tag

      if tag.match?(/<script/)
        split_tag = match.post_match.split(/<\/script>/, 2)
        elements.push(split_tag[0], "</script>")
        html = split_tag[1]
      elsif tag.match?(/<style/)
        split_tag = match.post_match.split(/<\/style>/, 2)
        elements.push(split_tag[0], "</style>")
        html = split_tag[1]
      else
        html = match.post_match
      end
    end
    elements
  end

  def closing_tag?(element)
    element.start_with?("</")
  end

  def opening_tag?(element)
    element.start_with?("<")
  end

  def handle_opening_tag(element)
    name = tag_name(element)
    attributes = tag_attributes(element)

    if !root.children?
      @current_node = current_node.add_child(name, attributes)
    elsif self_closing_tag?(name)
      if !current_node.children?
        current_node.add_child(name, attributes)
      else
        current_node.add_sibling(name, attributes)
      end
    else
      @current_node = current_node.add_child(name, attributes)
    end
  end

  def handle_text_content(element)
    current_node[:children] << element
  end

  def tag_name(element)
    element.match(/<([^>\s]+)/)[1]
  end

  def tag_attributes(element)
    attr_pairs = extract_attribute_pairs(element)

    attr_pairs.map do |attr|
      name, value = attr.split("=")
      NodeAttribute.new(name, value.gsub(/"/, ""))
    end
  end

  def extract_attribute_pairs(attr_string)
    attr_string.scan(/(?:\S+\s*=\s*"[^"]*"|\S+\s*=\s*\S+)/)
  end

  def go_to_parent
    @current_node = @current_node.parent
  end

  def self_closing_tag?(tag_name)
    %w[area base br col command embed hr img input keygen link meta param source track wbr].include?(tag_name)
  end
end