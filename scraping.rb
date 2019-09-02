require 'httparty'
require 'nokogiri'
require 'pry'
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'

PREFIX = 'https://www.ufc.com'

Capybara.configure do |c|
  c.run_server = false
  c.default_driver = :selenium_chrome
  c.app_host = PREFIX
end

class UFCScraper
  include Capybara::DSL

  def scrape
    visit '/athletes/all'
    
    begin
      while true do
        find(:xpath, '//a[@rel="next"]').click
        # manual sleep: problem when next button appears while more profiles getting uploaded
        sleep 2
      end
    rescue
    end

    doc = Nokogiri::HTML.parse(page.source)
    a_tags = doc.xpath('//*[@class="l-flex__item"]//a[@class="e-button--black "]')
    names  = doc.xpath('//div[@class="c-listing-athlete-flipcard__front"]//span[@class="c-listing-athlete__name"]')
    results = names.zip(a_tags).to_h

    results.each do |k, v|
      scrape_athlete(v[:href])
    end
  end

  def scrape_athlete(href)
    visit href

    begin
      while true do
        find(:xpath, '//a[@rel="next"]').click
        sleep 2
      end
    rescue
    end

    doc = Nokogiri::HTML.parse(page.source)
    fights = doc.xpath('//*[@class="c-card-event--athlete-results__headline"]')
    fights.each { |f| puts f.text }

  end
end

UFCScraper.new.scrape
