class Specialization
  
  attr_reader :name, :url
  attr_writer :single_target_rotation, :aoe_rotation, :cooldowns
  attr_accessor :parent_class
  
  @@all = []
  
  VALID_MENU_OPTIONS = [
    "single target rotation",
    "aoe rotation",
    "cooldowns"
  ]
  
  def initialize(spec_name, url)
    @name = spec_name
    @url = url
    self.class.all << self
  end
  
  def populate_rotations_and_cooldowns
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
  
  def show_menu_options
    all_options = []
    VALID_MENU_OPTIONS.each do |option|
      all_options << option
    end
    puts all_options.join(" | ")
  end
  
  def self.all
    @@all
  end
end