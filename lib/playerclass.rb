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
      self.specializations << Specialization.new(spec_name, url)
    end
  end
  
  def show_specializations
    self.specializations.each do |spec|
      puts spec.name
    end
  end
  
  def get_spec_by_name(spec_name)
    self.specializations.detect{ |spec| spec.name.to_s == spec_name }
  end
  
  def self.prompt_user_to_select
    chosen_class = nil
    while chosen_class.nil?
      puts "What class would you like to look at? ('exit' to quit)"
      puts "'quit' to quit, 'show classes' to view all options"
      input = gets.strip
      case input
      when "show classes"
        self.print_all_classes
      else
       chosen_class = PlayerClass.find_by_class_name(input)
       puts "invalid option " if chosen_class.nil?
      end
    end
    chosen_class
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