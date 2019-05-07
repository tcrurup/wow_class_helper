class Specialization
  
  attr_reader :name, :url
  
  @@all = []
  
  def initialize(spec_name, url)
    @name = spec_name
    @url = url
    self.class.all << self
  end
  
  def self.all
    @@all
  end
end