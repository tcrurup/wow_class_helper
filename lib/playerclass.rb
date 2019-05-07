class PlayerClass
  
  @@all = []
  
  attr_reader :name
  
  def initialize(class_name, spec_hash)
    @name = class_name
    self.create_specializations
  end
  
  def create_specializations(spec_hash)
    spec_hash.each do |key, value|
      
    end
  end
  
end