class Specialization
  
  attr_reader :name, :url
  attr_accessor :single_target_rotation, :aoe_rotation, :cooldowns
  
  @@all = []
  
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
  
  def self.all
    @@all
  end
end