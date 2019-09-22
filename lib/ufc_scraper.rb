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
    fighter_props[:href]   = href
    fighter_props[:name]   = doc.xpath('//div[@class="field field-name-name"]').text
	  fighter_props[:debut]  = Date.parse(get_content_from_label(doc, 'Octagon Debut'))
	  fighter_props[:active] = fighter_active?(get_content_from_label(doc, 'Status'))
    fighter_props[:age]    = get_content_from_label(doc, 'Age').to_i
    fighter_props[:height] = get_content_from_label(doc, 'Height').to_f
    fighter_props[:reach]  = get_content_from_label(doc, 'Reach').to_f

    Fighter.create!(fighter_props)
  end

  def scrape_event(href)
    visit href

    doc = Nokogiri::HTML.parse(page.source)

    event_props = {}
    event_props[:href] = href
    event_props[:name] = doc.xpath('//*[@class="c-hero__headline-prefix"]//*/h2').text.strip

    event = Event.create!(event_props)

    fights = doc.xpath('//*[@class="c-listing-fight"]')

    fights.each do |fight|
      scrape_fight(event, fight["data-fmid"])
    end
  end

  # ufc uses 'fmid' to mark different fights, it's an id that they use presumably
  def scrape_fight(event, fmid)
    visit event + '#' + fmid.to_s

    doc = Nokogiri::HTML.parse(page.source)

    # I wonder if there could be some way for me to figure this out on my own
    # I'm sure this has to do with some event id thing
    visit doc.xpath('//iframe[@id="matchup-modal-content"]').first[:src]

    sleep 100

    doc = Nokogiri::HTML.parse(page.source)

    contents = doc.xpath('//*[contains(@class, "col-span-6")]')

    fight_props = {}
    fight_props[:event_id]          = 0
    fight_props[:first_fighter_id]  = 0
    fight_props[:second_fighter_id] = 0
    fight_props[:weight_class_id]   = 0
    fight_props[:victor_id]         = 0
    fight_props[:fight_id]          = 0
  end

  private

  def fighter_active?(text)
    text.strip.lowercase == "active"
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
