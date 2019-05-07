require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  BASE_PATH = "https://www.icy-veins.com/wow/"
  
  def initialize
  end
  
  def self.scrape_base_classes
    page = Nokogiri::HTML(open(BASE_PATH))  
    classes = page.css("div#nav_classes div.nav_content_block.nav_content_block_wow_class")
    all_classes = []
    
    classes.each do |player_class|
      class_hash = {}
      spec_hash = {}
      class_hash[:name] = player_class.css("div.nav_content_block_title span:last-child").text
      
      
      player_class.css("div.nav_content_block_entry a").each do |specialization|
        spec_name = specialization.text
        unless spec_name.include?("Leveling")
          spec_url = specialization.attribute("href").text
          spec_hash[spec_name.to_sym] = spec_url
        end
      end
      
      class_hash[:specializations] = spec_hash
      all_classes << class_hash
    end
    
    all_classes
  end
end