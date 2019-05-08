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
    
    rotations_url = self.find_cooldowns_and_rotations_url(spec_page)
    rotations_page = Nokogiri::HTML(open(rotations_url))
    
    self.scrape_rotations_and_cooldowns(rotations_page).each do |key, value|
      spec_hash[key.to_sym] = value 
    end
  end
  
  def self.find_cooldowns_and_rotations_url(spec_page)
    spec_page.css("ul.content-main-menu>li").each do |menu_option|
      if menu_option.css("a").text.downcase.include?("cooldown")
        return menu_option.css("a").attribute("href").text 
      end
    end
  end
  
  def self.scrape_rotations_and_cooldowns(rotations_page)
    
    #There are three lists on every page and the all correlate the same.  Single target rotation 
    #is always first, followed by AOE, and finally Cooldowns.  These lists are put into an array 
    #and accessed via their index number
    
    rotations_and_cooldowns_hash = {}
    page_elements = rotations_page.css("div.content-main>div.center-wrap-max").css("div.center-wrap-max").children
    
    element = page_elements.first
    single_target_rotation_elements = []
    aoe_rotation_elements = []
    cooldown_elements = []
    
    
    until element.text == "Single Target Rotation"
      #Do nothing, nothing before the first rotation list is needed
      element = element.next
    end
    
    until element.text == "AoE Rotation"
      #Everything before AoE rotation section belongs to Single Target Rotation
      single_target_rotation_elements << element
      element = element.next
    end
    
    until element.text == "Effective Cooldowns"
      aoe_rotation_elements << element
      element = element.next
      #Everything before Effective Cooldowns section belongs to AoE Rotation
    end
    
    until element.next == nil
      cooldown_elements << element
      element = element.next
    end

    data_hash = {}
    data_hash[:notes] = Array.new
    single_target_rotation_elements.each do |e| 
      if e.name == "h1" 
        data_hash[:title] = e.text
      elsif e.name == "p" && e.text != "" 
        data_hash[:notes] << e.text
      elsif e.name == "ol" || e.name == "ul"
        data_hash[:list] = scrape_from_element_list(e)
      end
    end
    binding.pry
  end
  
  def self.scrape_from_element_list(rotation_elements)
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