class CommandLineInterface
  
  attr_accessor :status, :selected_class
  
  
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
        
        current_spec = self.selected_class.prompt_user_to_select_specialization
        unless current_spec.nil?
        
        current_spec.menu_prompt
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
  
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash[:name], class_hash[:specializations])
    end
  end
  
end