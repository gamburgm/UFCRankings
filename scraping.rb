require 'httparty'
require 'nokogiri'
require 'pry'

PREFIX = 'https://www.ufc.com'

doc = Nokogiri::HTML.parse(HTTParty.get(PREFIX + '/athletes/all'))
# would it be possible to search for one node and then do multiple child searches from there?
a_tags = doc.xpath('//*[@class="l-flex__item"]//a[@class="e-button--black "]')
names  = doc.xpath('//div[@class="c-listing-athlete-flipcard__front"]//span[@class="c-listing-athlete__name"]')


results = names.zip(a_tags).to_h

results.each do |k, v|
	puts k.text.strip + ' => ' + v[:href]
end