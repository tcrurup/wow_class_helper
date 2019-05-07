class Specialization
  
  attr_reader :name, :url
  
  @@all = []
  
  def initialize(spec_name, url)
    @name = spec_name
    @url = url
    self.class.all << self
  end
  
  def self.populate_all_specializations
    self.all.each do |spec|
      spec_hash = Scraper.scrape_specialization(spec.url)
    end
  end
  
  def self.all
    @@all
  end
end