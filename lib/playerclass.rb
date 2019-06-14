class PlayerClass
  
  @@all = []
  
  attr_accessor :specializations
  attr_reader :name, :spec_url_hash
  
  
  def initialize(class_hash)
    
    #spec_hash is a hash that has keys that represent the specialization names and the value are the url to the specializations main page
    
    @name = class_hash[:name]
    @spec_url_hash = class_hash[:specializations]
    self.specializations = []
    self.save
  end
  
  def populate_specializations
    self.spec_url_hash.each do |spec_name, url|
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
    self.specializations.detect{ |spec| 
      spec.name.to_s.downcase == spec_name.downcase
    }.tap do |spec_obj|
      spec_obj.populate_rotations_and_cooldowns
    end
  end
  
  def self.has_spec(spec_name)
    
  end
  
  def save
    self.class.all << self
  end
  
  def self.all 
    @@all
  end
  
  def self.find_by_class_name(class_name)
    self.all.detect{ |player_class| 
      player_class.name.downcase == class_name.downcase 
    }.tap do |pc|
      pc.populate_specializations
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