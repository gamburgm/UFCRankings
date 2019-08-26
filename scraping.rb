require 'httparty'
require 'nokogiri'

PREFIX = 'https://www.ufc.com'

puts "beginning"
doc = Nokogiri::HTML.parse(HTTParty.get(PREFIX + '/athletes/all'))
puts "parsed part 1"
elements = doc.xpath('//*[@class="l-flex__item"]//a[@class="')
puts "identified part 1"

athletes = elements.map do |e|
	puts PREFIX + e[:href]
	Nokogiri::HTML.parse(HTTParty.get(PREFIX + e[:href]))
end

puts "parsed part 2"

file = File.open('interesting.txt', 'w')
athletes.each { |a| file.puts a.xpath('//*[@class="c-record__promoted"][1]').text }
puts "identified part 2"

file.close
