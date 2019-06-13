class PlayerClass
  
  @@all = []
  
  attr_accessor :specializations
  attr_reader :name
  
  
  def initialize(class_name, spec_hash)
    @name = class_name
    self.specializations = []
    self.add_specializations(spec_hash)
    self.save
  end
  
  def add_specializations(spec_hash)
    spec_hash.each do |spec_name, url|
      new_spec = Specialization.new(spec_name, url)
      self.specializations << new_spec
      new_spec.parent_class = self
    end
  end
  
  def show_specializations
    all_specs = []
    self.specializations.each do |spec|
      all_specs << spec.name
    end
    puts all_specs.join(" | ")
  end
  
  def get_spec_by_name(spec_name)
    self.specializations.detect{ |spec| spec.name.to_s.downcase == spec_name.downcase}
  end
  
  def prompt_user_to_select_specialization
    chosen_specialization = nil
    while chosen_specialization.nil?
      puts "What specialization would you like to look at?"
      self.show_specializations
      input = gets.strip
      chosen_specialization = self.get_spec_by_name(input)
      puts "invalid option " if chosen_specialization.nil?
    end
    chosen_specialization
  end
  
  def save
    self.class.all << self
  end
  
  def self.all 
    @@all
  end
  
  def self.find_by_class_name(class_name)
    self.all.detect{ |player_class| player_class.name.downcase == class_name.downcase }
  end
  
  def self.print_all_classes
    self.all.each{ |player_class| puts player_class.name }
  end
  
end