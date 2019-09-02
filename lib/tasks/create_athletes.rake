require 'ufc_scraper'

desc "backfill the database"
task :backfill_db do
  UFCScraper.new.scrape
end
