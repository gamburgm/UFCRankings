require 'capybara/dsl'

PREFIX = 'https://www.ufc.com'

class UFCScraper
  Capybara.configure do |c|
    c.run_server = false
    c.default_driver = :selenium#_chrome
    c.app_host = PREFIX
    c.default_selector = :xpath
  end

  include Capybara::DSL

  def scrape_athletes
    visit '/athletes/all'

    iterate_button('//a[@rel="next"]')

    doc = Nokogiri::HTML.parse(page.source)
    a_tags = doc.xpath('//*[@class="l-flex__item"]//a[@class="e-button--black "]')
    names  = doc.xpath('//div[@class="c-listing-athlete-flipcard__front"]//span[@class="c-listing-athlete__name"]')
    results = names.zip(a_tags).to_h

    puts results.length

    results.each do |k, v|
      scrape_athlete(v[:href])
    end
  end

  def scrape_events
    visit '/events#events-list-past'

    iterate_button('//*[contains(@class, "view-display-id-past")]//a[@rel="next"]')

    doc = Nokogiri::HTML.parse(page.source)

    events = doc.xpath('//*[@id="events-list-past"]//article[@class="c-card-event--result"]//div[@class="c-card-event--result__header"]//a')

    events.each do |event|
      scrape_event(event)
    end
  end

  def scrape_athlete(href)
    visit href

    doc = Nokogiri::HTML.parse(page.source)

    fighter_props = {}
    fighter_props[:href] = href

    # this doesn't work. What happens when somebody has a middle name? Do I add a middle name field? Or just do first and last?
    name_list = doc.xpath('//div[@class="field field-name-name"]').text.split(' ')
    fighter_props[:first_name] = name_list.first
    fighter_props[:last_name]  = name_list.last
    # could have a middle name where I join all but the first and last
	  fighter_props[:debut]      = Date.parse(get_content_from_label(doc, 'Octagon Debut'))
	  fighter_props[:active]     = fighter_active?(get_content_from_label(doc, 'Status'))
    fighter_props[:age]        = get_content_from_label(doc, 'Age').to_i
    fighter_props[:height]     = get_content_from_label(doc, 'Height').to_f
    fighter_props[:reach]      = get_content_from_label(doc, 'Reach').to_f

    Fighter.create!(fighter_props)
  end

  def scrape_event(href)
    visit href

    doc = Nokogiri::HTML.parse(page.source)
    # this includes **all** fights, including prelim and early prelim fights
    fights = doc.xpath('//*[@class="c-listing-fight"]')

    fights.each do |fight|
      # don't know if this syntax actually works
      scrape_fight(href, fight["data-fmid"])
    end
  end

  # ufc uses 'fmid' to mark different fights, it's an id that they use presumably
  def scrape_fight(event, fmid)
    # visit event.to_href + '#' fmid.to_s
    first_name, last_name = doc.xpath('//h2[@class="field---name-name name_given red"]').text.strip.split(' ')
    first_fighter = Fighter.where(first_name: first_name, last_name: last_name)
    first_name, last_name = doc.xpath('//h2[@class="field---name-name name_given blue"]').text.strip.split(' ')
    second_fighter = Fighter.where(first_name: first_name, last_name: last_name)
    # strat for finding winning fighter: find the div for the winning fighter, then go up divs until you find the href of the winning athlete
    # should I store the href for each athlete? That's probably the best way to have a unique identifier even, right?
  end

  private

  def fighter_active?(text)
    text.strip == "Active"
  end

  def iterate_button(xpath)
    begin
      while true do
        element = find(xpath, wait: 10)
        sleep 1
        element.click
      end
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "stale element reference error"
      retry
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      puts "element intercepted by other one"
      retry
    rescue Capybara::ElementNotFound
      return
    end
  end

  def get_content_from_label(doc, text)
    doc.xpath("//*/text()[normalize-space(.)='#{text}']/parent::*/parent::*/div[2]").text
  end
end
