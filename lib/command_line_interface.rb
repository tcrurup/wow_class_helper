class CommandLineInterface
  
  
  
  
  def intialize
  
  end
  
  def run
    self.create_all_classes
    Scraper.scrape_all_specializations
    #self.interface
  end
  
  def interface 
    puts "Welcome to the Wow Class Helper"
    chosen_class = nil
    while chosen_class.nil? 
      puts "What class would you like to look at?"
      input = gets.strip
      chosen_class = PlayerClass.find_by_class_name(input)
    end
  end
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash[:name], class_hash[:specializations])
    end
  end
  
end