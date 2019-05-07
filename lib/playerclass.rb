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
end