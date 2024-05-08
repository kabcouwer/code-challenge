require "json"
require "./lib/node_attribute"
require "./lib/node"
require "./lib/html_doc"
require "./lib/google_carousel_serializer"

html_file_path = "./files/van-gogh-paintings.html"
html = File.read(html_file_path)

serializer = GoogleCarouselSerializer.new(html)

puts serializer.call