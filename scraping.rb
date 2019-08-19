require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML.parse(open('https://www.ufc.com/athletes/all'))

elements = doc.xpath('//*[@class="l-flex__item"]/div/div/div/div/div/a')

prefix = 'https://www.ufc.com'

athletes = (0..10).map { |num| Nokogiri::HTML.parse(open(prefix + elements[num][:href])) unless num == 8 }

file = File.open('interesting.txt', 'a')

athletes.each { |a| file.puts a.xpath('//*[@class="c-record__promoted"][1]').text }

file.close
