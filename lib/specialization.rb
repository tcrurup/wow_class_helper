class Specialization
  
  attr_reader :name, :url
  attr_writer :single_target_rotation, :aoe_rotation, :cooldowns, :parent_class
  
  @@all = []
  
  VALID_MENU_OPTIONS = [
    "single target rotation",
    "aoe_rotation",
    "cooldowns"
  ]
  
  def initialize(spec_name, url)
    @name = spec_name
    @url = url
    self.assign_rotations_and_cooldowns
    self.class.all << self
  end
  
  def assign_rotations_and_cooldowns
      Scraper.scrape_rotations_and_cooldowns(self.url).each do |key, elements_array|
        new_page_section = PageSection.new(elements_array)
        self.send("#{key}=", new_page_section)
      end
  end
  
  def single_target_rotation
    @single_target_rotation.display
  end
  
  def aoe_rotation
    @aoe_rotation.display
  end
  
  def cooldowns 
    @cooldowns.display
  end
  
  def menu_prompt
    system("clear")
    puts "What would you like to view for #{self.parent_class.name} #{self.name}"
  end
  
  def self.all
    @@all
  end
end