class CommandLineInterface
  
  attr_accessor :status, :current_class
  
  
  def intialize
    @status = "ready"
    @current_class = nil
  end
  
  def run
    self.create_all_classes
    self.status = "running"
    self.interface
  end
  
  def interface 
    system("clear")
    puts "Welcome to the Wow Class Helper"
    while self.status == "running" && self.current_class == nil
      self.current_class = self.prompt_for_class
      if self.current_class.class == PlayerClass
        
        chosen_spec = prompt_for_specialization
        #Ask for specialization
      end
    end
  end
  
  def prompt_for_specialization
    
  end
  
  def prompt_for_class
    
    chosen_class = nil
    puts "What class would you like to look at? ('exit' to quit)"
    puts ("'exit' to quit, 'show classes' to view all options")
    input = gets.strip
    case input
    when "show classes"
      PlayerClass.print_all_classes
    when "exit"
      self.status = "closing"
    else
      chosen_class = PlayerClass.find_by_class_name(input)
      puts "invalid option " if chosen_class.nil?
    end
    chosen_class
  end
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash[:name], class_hash[:specializations])
    end
  end
  
end