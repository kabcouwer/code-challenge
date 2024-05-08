require "json"

class GoogleCarouselSerializer
  def initialize(html)
    @html = html
    @source = "https://www.google.com"
    @doc = HTMLDoc.new(html)
  end

  def call
    serialize(items)
  end

  private

  attr_reader :html, :source, :doc

  def serialize(items)
    JSON.parse({ "data" => items }.to_json)
  end

  def items
    items = doc.css("klitem")

    items.map do |item|
      name, extensions = extract_name_and_extensions(item)
      link = extract_link(item)

      { name: name, extensions: extensions, link: link }
    end
  end

  def extract_name_and_extensions(item)
    title = item.get_value_from_attribute("title")
    split = title.split(/\s*\(\s*|\s*\)\s*/)
    name = split[0]
    extensions = split[1].nil? ? [] : split[1].split(", ").map(&:strip)

    [name, extensions]
  end

  def extract_link(item)
    source + item.get_value_from_attribute("href")
  end
end
