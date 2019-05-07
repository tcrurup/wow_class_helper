require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  BASE_PATH = "https://www.icy-veins.com/wow/"
  ROTATION_URL_ENDING = "rotation-cooldown-abilities"
  
  def initialize
  end
  
  def self.scrape_all_specializations
    Specialization.all.each do |spec|
      rotation_url = spec.url.split("-")[0...-1] << ROTATION_URL_ENDING
      page = Nokogiri::HTML(open(rotation_url.join('-')))
      binding.pry
    end
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
          spec_url = specialization.attribute("href").text.gsub(/\/{2}/, "")
          binding.pry
          spec_hash[spec_name.to_sym] = spec_url
        end
      end
      
      class_hash[:specializations] = spec_hash
      all_classes << class_hash
    end
    
    all_classes
  end
end