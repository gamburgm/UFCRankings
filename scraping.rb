require 'httparty'
require 'nokogiri'
require 'pry'

PREFIX = 'https://www.ufc.com'

doc = Nokogiri::HTML.parse(HTTParty.get(PREFIX + '/athletes/all'))
# would it be possible to search for one node and then do multiple child searches from there?
a_tags = doc.xpath('//*[@class="l-flex__item"]//a[@class="e-button--black "]')
names  = doc.xpath('//div[@class="c-listing-athlete-flipcard__front"]//span[@class="c-listing-athlete__name"]')

names.each do |n|
	puts n.text.strip()
end

# athletes = elements.map do |e|
# 	Nokogiri::HTML.parse(HTTParty.get(PREFIX + e[:href]))
# end

# file = File.open('interesting.txt', 'w')
# athletes.each { |a| file.puts a.xpath('//*[@class="c-record__promoted"][1]').text }

# file.close
