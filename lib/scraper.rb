require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  BASE_PATH = "https://www.noxxic.com/wow/"
  
  def initialize
  end
  
  def self.scrape_specialization(spec_url)
    spec_hash = {}
    
    #Spec_page is the main page for the class specialization.  We will parse out the HTML
    #for certain links for every class page since each one is setup different
    spec_page = Nokogiri::HTML(open(spec_url))
    
    rotations_url = spec_page.css("ul.content-main-menu>li").last.css("a").attribute("href").value
    rotations_page = Nokogiri::HTML(open(rotations_url))
    
    spec_hash[:single_rotation] = self.scrape_single_rotation(rotations_page)
  end
  
  def self.scrape_single_rotation(rotations_page)
    rotation_lists = rotations_page.css("div.content-main>div.center-wrap-max").css("div.center-wrap-max").css("ol, ul")
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