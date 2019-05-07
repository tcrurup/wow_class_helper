require 'nokogiri'
require 'open-uri'

class Scraper
  
  BASE_PATH = "https://www.icy-veins.com/wow/"
  
  def initialize
  end
  
  def self.scrape_base_classes
    page = Nokogiri::HTML(open(BASE_PATH))  
  end
end