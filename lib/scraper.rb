require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  BASE_PATH = "https://www.noxxic.com/wow/"
  
  def initialize
  end
  
  def self.scrape_specialization(spec_url)
    spec_hash = {}
    rotation_url = spec_url.split("-")[0...-1] << ROTATION_URL_ENDING
    page = Nokogiri::HTML(open("https://#{rotation_url.join("-")}"))
  end
  
  def self.scrape_base_classes
    page = Nokogiri::HTML(open(BASE_PATH))  
    classes = page.css("ul.dr>li")
    all_classes = []
    classes.each do |player_class|
      class_hash = {}
      class_hash[:name] = player_class.css("a").first.text
      
      spec_hash = {}
      player_class.css("ul li").each do |specialization|
        spec_name = specialization.text
        spec_url = specialization.css("a").attribute("href").value
        spec_hash[spec_name.to_sym] = spec_url
      end
      
      class_hash[:specializations] = spec_hash
      all_classes << class_hash
    end
    all_classes
  end
end