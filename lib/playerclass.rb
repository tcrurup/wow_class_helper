class PlayerClass
  
  @@all = []
  
  attr_accessor :specializations
  attr_reader :name
  
  
  def initialize(class_name, spec_hash)
    
    #spec_hash is a hash that has keys that represent the specialization names and the value are the url to the specializations main page
    
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