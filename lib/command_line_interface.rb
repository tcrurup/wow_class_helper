class CommandLineInterface
  
  
  
  
  def intialize
  
  end
  
  def run
    self.create_all_classes
    self.interface
    
  end
  
  def interface 
    puts "Welcome to the Wow Class Helper"
    puts "What class would you like to look at?"
    chosen_class = nil
    while chosen_class.nil? 
      input = gets.strip
      PlayerClass.find_by_class_name(input).nil?
    end
  end
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      new_class = PlayerClass.new(class_hash[:name])
      new_class.add_specializations(class_hash[:specializations])
    end
  end
  
  
end