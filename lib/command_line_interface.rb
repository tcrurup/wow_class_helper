class CommandLineInterface
  
  attr_accessor :status, :selected_class, :selected_spec
  
  
  def initialize
    self.create_all_classes
    @status = "ready"
  end
  
  def run
    self.status = "running"
    self.interface
  end
  
  def interface 
    system("clear")
    puts "Welcome to the Wow Class Helper"
    while self.status == "running" 
      
      self.prompt_user_to_select_class
      unless self.selected_class.nil?
        
        self.prompt_user_to_select_specialization
        unless self.selected_spec.nil?
        
        self.selected_spec.menu_prompt
        end
      end
    end
  end
  
  def prompt_user_to_select_class
    chosen_class = nil
    while chosen_class.nil?
      puts "What class would you like to look at? ('exit' to quit)"
      puts "'quit' to quit, 'show classes' to view all options"
      input = gets.strip
      case input
      when "show classes"
        PlayerClass.print_all_classes
      else
       chosen_class = PlayerClass.find_by_class_name(input)
       puts "invalid option " if chosen_class.nil?
      end
    end
    self.selected_class = chosen_class
  end
  
  def prompt_user_to_select_specialization
    chosen_specialization = nil
    while chosen_specialization.nil?
      puts "What specialization would you like to look at?"
      self.selected_class.show_specializations
      input = gets.strip
      chosen_specialization = self.selected_class.get_spec_by_name(input)
      puts "invalid option " if chosen_specialization.nil?
    end
    self.selected_spec = chosen_specialization
  end
  
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash[:name], class_hash[:specializations])
    end
  end
  
end