require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  BASE_PATH = "https://www.icy-veins.com/wow/"
  
  def initialize
  end
  
  def self.scrape_base_classes
    page = Nokogiri::HTML(open(BASE_PATH))  
    classes = page.css("div.nav_content_block.nav_content_block_wow_class")
    
    classes.each do |player_class|
      class_name = player_class.css("div.nav_content_block_title span:last-child").text
    end
    
  end
end