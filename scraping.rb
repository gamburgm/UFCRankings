require 'httparty'
require 'nokogiri'

doc = Nokogiri::HTML.parse(HTTParty.get('https://www.ufc.com/athletes/all'))

elements = doc.xpath('//*[@class="l-flex__item"]/div/div/div/div/div/a')
puts "we made it here"

prefix = 'https://www.ufc.com'

athletes = (0..10).map { |num| Nokogiri::HTML.parse(HTTParty.get(prefix + elements[num][:href]))  }

athletes.each_with_index { |a, i| puts i if a == nil }

file = File.open('interesting.txt', 'w')

athletes.each { |a| file.puts a.xpath('//*[@class="c-record__promoted"][1]').text }

file.close
