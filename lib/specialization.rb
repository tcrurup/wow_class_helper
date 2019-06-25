class Specialization

  attr_reader :name, :url, :populated
  attr_writer :single_target_rotation, :aoe_rotation, :cooldowns
  attr_accessor :parent_class

  @@all = []

  VALID_MENU_OPTIONS = [
    "Single Target Rotation",
    "Aoe Rotation",
    "Cooldowns"
  ]

  def initialize(spec_name, url)
    @name = spec_name
    @url = url
    @populated = false
    self.class.all << self
  end

  def populate_rotations_and_cooldowns
    unless self.populated
      Scraper.scrape_rotations_and_cooldowns(self.url).each do |key, elements_array|
        self.send("#{key}=", PageSection.new(elements_array))
      end
      @populated = true
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
    puts "             OPTIONS                "
    puts '----------------------------------------------------------------------'
    puts all_options.join(" | ")
    puts '----------------------------------------------------------------------'
  end

  def self.all
    @@all
  end

   def self.get_spec_by_name(spec_name)
    index = self.all.detect{ |spec| spec.name.to_s.downcase == spec_name.downcase }

    if !index.nil? && !index.populated
      index.populate_rotations_and_cooldowns
    end

    index
  end

end
