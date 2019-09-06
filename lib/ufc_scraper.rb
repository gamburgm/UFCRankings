require 'capybara/dsl'

PREFIX = 'https://www.ufc.com'

class UFCScraper
  Capybara.configure do |c|
    c.run_server = false
    c.default_driver = :selenium_chrome
    c.app_host = PREFIX
  end

  include Capybara::DSL

  def scrape_athletes
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

    doc = Nokogiri::HTML.parse(page.source)

    fighter_props = {}

    first_name, last_name = doc.xpath('//div[@class="field field-name-name"]').text.split(' ')
	  fighter_props[:first_name] = first_name
	  fighter_props[:last_name]  = last_name
	  fighter_props[:debut]      = Date.parse(get_content_from_label(doc, 'Octagon Debut'))
	  fighter_props[:active]     = fighter_active?(get_content_from_label(doc, 'Status'))
    fighter_props[:age]        = get_content_from_label(doc, 'Age').to_i
    fighter_props[:height]     = get_content_from_label(doc, 'Height').to_i 
    fighter_props[:reach]      = get_content_from_label(doc, 'Reach').to_i
#    debut = Date.parse(doc.xpath("//*/text()[normalize-space(.)='Octagon Debut']/parent::*/parent::*/div[2]").text.strip)
    
#    status = fighter_active?(doc.xpath("//*/text()[normalize-space(.)='Status']/parent::*/parent::*/div[2]").text)
    Fighter.create!(fighter_props)
  end

  private

  def fighter_active?(text)
    text.strip == "Active"
  end

  def iterate_button(xpath)
    begin
      while true do
        find(:xpath, xpath).click
        sleep 2
      end
    rescue
    end
  end

  def get_content_from_label(doc, text)
    doc.xpath("//*/text()[normalize-space(.)='#{text}']/parent::*/parent::*/div[2]").text
  end
end
