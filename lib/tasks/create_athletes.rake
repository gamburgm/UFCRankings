desc "scrape for all athletes ever present in the ufc"
task create_athletes: :environment do
  UFCScraper.new.scrape_athletes
end

desc "create the weightclasses using a csv"
task create_weight_classes: :environment do
  CSV.foreach(Rails.root.join('lib/weight_classes.csv'), headers: true) do |w|
    WeightClass.create!(w.to_h)
  end
end

desc "scrape for all events and fights that have occurred in the ufc"
task create_events_and_fights: :environment do
  UFCScraper.new.scrape_fight('/event/ufc-242', '7934')
end

