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
    
    self.scrape_rotations_and_cooldowns(rotations_page).each do |key, value|
      spec_hash[key.to_sym] = value 
    end
    binding.pry
  end
  
  def self.scrape_rotations_and_cooldowns(rotations_page)
    
    #There are three lists on every page and the all correlate the same.  Single target rotation 
    #is always first, followed by AOE, and finally Cooldowns.  These lists are put into an array 
    #and accessed via their index number
    
    rotations_and_cooldowns_hash = {}
    rotation_lists = rotations_page.css("div.content-main>div.center-wrap-max").css("div.center-wrap-max").css("ol, ul")
    rotations_and_cooldowns_hash[:single_target_rotation] = self.scrape_single_target_rotation(rotation_lists[0])
    rotations_and_cooldowns_hash
  end
  
  def self.scrape_single_target_rotation(rotation_elements)
    rotation = []
    rotation_elements.css("li").each do |rotation_step|
      str = []
      
      ##Each rotation step on the website also contains links to certain abilities.  This will 
      #leave any regular text alone and transform any hyperlinks into regular text
      rotation_step.children.each do |child|
        
        #While both of these are the same I want to leave space to create Ability objects and the 
        #Nokogiri::XML::Element will return elements that contain data for scraping 
        case child
          when Nokogiri::XML::Text 
            str << child.text.strip
          when Nokogiri::XML::Element 
            str << child.text.strip
        end
      end
      rotation << str.join(" ")
    end
    rotation
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