require "nokogiri"
require "json"

class HtmlParser
  def initialize(html_file_path)
    @html_file_path = html_file_path
    @source = "https://www.google.com"
  end

  def call
    parse_html_file
  end

  private

  attr_reader :html_file_path, :source

  def parse_html_file
    doc = load_html_file
    items_label = get_items_label(doc)
    items = get_items(doc)
    items_array = get_items_array(items)
    output_result(items_label, items_array)
  end

  def load_html_file
    File.open(html_file_path) { |f| Nokogiri::HTML(f) }
  end

  def get_items_label(doc)
    doc.css(".kxbc")[1].text.downcase.strip
  end

  def get_items(doc)
    doc.css(".klitem")
  end

  def get_items_array(items)
    items.map do |item|
      name = item.css(".kltat").text.strip
      meta = item.css(".klmeta").text.strip
      extensions = meta.split(",").map(&:strip)
      link = source + item["href"]

      { name: name, extensions: extensions, link: link }
    end
  end

  def output_result(items_label, array)
    JSON.parse({ items_label => array }.to_json)
  end
end
