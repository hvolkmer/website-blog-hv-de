require 'nokogiri'

module Jekyll
  module ImageURLFilter

    def absolute_image_url(input)
      doc = Nokogiri(input)
      doc.search("//img").each do |img| 
        img['src'] = "http://blog.hendrikvolkmer.de#{img['src']}" if img['src'][0] == "/"
      end
      doc.to_html
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageURLFilter)

