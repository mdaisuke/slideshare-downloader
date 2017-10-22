require 'bundler'
Bundler.require

require 'open-uri'

url = ARGV[0]

driver = Selenium::WebDriver.for :chrome
driver.navigate.to url
max = driver.find_element(css: '.j-total-slides').text.to_i
elem = driver.find_element(css: '.j-next-btn.arrow-right')
(max-1).times{elem.click}

srcs = driver.find_elements(css: '.slide_image').map{|elem|
  elem.attribute(:src)
}
driver.quit

files = []
srcs.each_with_index do |src, i|
  img = open(src)
  filename = "slideshare-#{i}.jpg"
  files << filename
  File.open(filename, 'wb') do |file|
    file.write img.read
  end
end

list = Magick::ImageList.new(*files)
list.write("slideshare.pdf")
