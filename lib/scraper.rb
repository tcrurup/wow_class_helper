require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  BASE_PATH = "https://www.noxxic.com/wow/"
  
  def initialize
  end
  
  def self.find_cooldowns_and_rotations_url(spec_page)
    spec_page.css("ul.content-main-menu>li").each do |menu_option|
      if menu_option.css("a").text.downcase.include?("cooldown")
        return menu_option.css("a").attribute("href").text 
      end
    end
  end
  
  def self.scrape_rotations_and_cooldowns(spec_page_url)
    
    page_sections = {
      :single_target_rotation => [],
      :aoe_rotation => [],
      :cooldowns => []
    }
    
    #Open the main specialization page then use the Scraper to find the url for the cooldowns and rotations page.  Then open that page and grab the bulk of the page elements to sort through individually
    spec_page = Nokogiri::HTML(open(spec_page_url))
    page_url =  self.find_cooldowns_and_rotations_url(spec_page)
    rotations_page = Nokogiri::HTML(open(page_url))
    page_elements = rotations_page.css("div.content-main>div.center-wrap-max").css("div.center-wrap-max").children
    
    single_target_rotation_elements = []
    aoe_rotation_elements = []
    cooldown_elements = []
    element = page_elements.first
    
    until element.text == "Single Target Rotation"
      #Do nothing, nothing before the first rotation list is needed
      element = element.next
    end
    
    until element.text == "AoE Rotation"
      #Everything before AoE rotation section belongs to Single Target Rotation
      page_sections[:single_target_rotation] << element
      element = element.next
    end
    
    until element.text == "Effective Cooldowns"
      page_sections[:aoe_rotation] << element
      element = element.next
      #Everything before Effective Cooldowns section belongs to AoE Rotation
    end
    
    until element.next == nil
      page_sections[:cooldowns] << element
      element = element.next
    end
    
    page_sections
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
    
    #returns an array of hashes.  Each hash has a :name for the class and :specializations which is another hash containing the spec name as a key and that specializations url as the value
    <<-EXAMPLE
    [
      {:name => 'Mage', 
        :specializations => {
          :fire => 'fireurl.com',
          :frost => 'frosturl.com',
          :arcane => 'arcaneurl.com'
        }
      },
      {name => 'Druid,
        :specializations => {
          :feral => 'feralurl.com',
          :restoration => 'restorationurl.com',
          :balance => 'balanceurl.com'
          :guardian => 'guardianurl.com'
        }
      }
    ] 
    EXAMPLE
    
    page = Nokogiri::HTML(open(BASE_PATH))  
    classes = page.css("li.dd").first.css("ul.dr>li")
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