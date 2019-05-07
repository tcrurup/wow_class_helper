class PlayerClass
  
  @@all = []
  
  attr_reader :name
  
  def initialize(class_name)
    @name = class_name
    @specializations = []
    self.class.all << self
  end
  
  def add_specializations(spec_hash)
    spec_hash.each do |spec_name, url|
      new_spec = Specialization.new(spec_name)
    end
  end
  
  def self.all 
    @@all
  end
  
  def self.find_by_class_name(class_name)
    self.all.detect{ |player_class| player_class.name.downcase == class_name.downcase }
  end
  
end