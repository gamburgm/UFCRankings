require 'capybara/dsl'

PREFIX = 'https://www.ufc.com'

class UFCScraper
  Capybara.configure do |c|
    c.run_server = false
    c.default_driver = :selenium_chrome
    c.app_host = PREFIX
  end

  include Capybara::DSL

  def scrape
    visit '/athletes/all'

    iterate_button('//a[@rel="next"]')

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

    iterate_button('//a[@rel="next"]')

    doc = Nokogiri::HTML.parse(page.source)
    fights = doc.xpath('//*[@class="c-card-event--athlete-results__headline"]')
    fights.each { |f| puts f.text }
  end

  private

  def iterate_button(xpath)
    begin
      while true do
        find(:xpath, xpath).click
        sleep 2
      end
    rescue
    end
  end
end
