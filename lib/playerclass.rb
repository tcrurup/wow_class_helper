class PlayerClass
  
  @@all = []
  
  attr_accessor :specializations
  attr_reader :name, :spec_url_hash, :populated
  
  
  def initialize(class_hash)
    
    #spec_hash is a hash that has keys that represent the specialization names and the value are the url to the specializations main page
    
    @name = class_hash[:name]
    @spec_url_hash = class_hash[:specializations]
    @populated = false
    self.specializations = []
    self.save
  end
  
  def populate_specializations
    self.spec_url_hash.each do |spec_name, url|
      new_spec = Specialization.new(spec_name, url)
      self.specializations << new_spec
      new_spec.parent_class = self
    end
    @populated = true
  end
  
  def show_specializations
    all_specs = []
    self.specializations.each do |spec|
      all_specs << spec.name
    end
    puts all_specs.join(" | ")
  end
  
  def get_spec_by_name(spec_name)
    Specialization.get_spec_by_name(spec_name) if self.has_specialization?(spec_name)
  end
  
  def has_specialization?(spec_name)
    self.specializations.any?{ |spec_obj| spec_obj.name.to_s.downcase == spec_name.downcase }
  end
  
  def save
    self.class.all << self
  end
  
  def self.all 
    @@all
  end
  
  def self.find_by_class_name(class_name)
    index = self.all.detect do |player_class| 
      player_class.name.downcase == class_name.downcase 
    end
    index.tap do |x| 
      x.populate_specializations unless index.populated
    end
  end
  
  def self.print_all_classes
    system('clear')
    puts "             CLASSES                "
    puts '------------------------------------'
    count = 0;
    self.all.each{ |player_class|
      count += 1
      print " #{player_class.name} "
      
      if count == 3
        count = 0
        puts ""
      else
        print "|"
      end
    }
    puts '------------------------------------'
  end
  
end