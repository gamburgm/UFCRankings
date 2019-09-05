require 'csv'
require 'pry'

task create_athletes: :environment do
  UFCScraper.scrape_athletes
end

task create_weight_classes: :environment do
  weight_classes = CSV.parse("../weight_classes.csv", headers: true)

  CSV.foreach(Rails.root.join('lib/weight_classes.csv'), headers: true) do |w|
    WeightClass.create!(w.to_h)
  end
end

task create_events_and_fights: :environment do
end

