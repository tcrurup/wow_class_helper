class CommandLineInterface
  
  attr_accessor :status, :selected_class, :selected_spec
  
  
  def initialize
    self.create_all_classes
    @status = "ready"
  end
  
  def run
    if self.status == "ready"
      self.status = "running"
      self.interface
    else
      puts "CLI is not ready to run."
    end
  end
  
  def interface 
    system("clear")
    puts "Welcome to the Wow Class Helper"
    while self.status == "running" 
      if self.selected_class.nil?
        self.prompt_user_to_select_class
        
      elsif self.selected_spec.nil?
        self.prompt_user_to_select_specialization
          
      else 
        self.prompt_user_for_spec_options
      end
    end
  end
  
  def prompt_user_to_select_class
    while self.selected_class.nil?
      puts "What class would you like to look at? ('exit' to quit)"
      puts "'quit' to quit, 'show classes' to view all options"
      input = gets.strip
      case input
        when "show classes"
          PlayerClass.print_all_classes
        when "exit"
          self.status = "ended"
        else
          self.selected_class = PlayerClass.find_by_class_name(input)
      end
      
      puts "invalid option " if self.selected_class.nil?
    end
  end
  
  def prompt_user_to_select_specialization
    chosen_specialization = nil
    input = ""
    while chosen_specialization.nil?
      system('clear')
      puts "What specialization would you like to look at?"
      self.selected_class.show_specializations
      input = gets.strip
      chosen_specialization = self.selected_class.get_spec_by_name(input)
      puts "invalid option " if chosen_specialization.nil?
    end
    self.selected_spec = chosen_specialization
  end
  
  def prompt_user_for_spec_options
    system("clear")
    input = String.new 
    until input == "back"
      puts "What would you like to view for the #{self.spec_name} #{self.char_class_name}?"
      puts "Type 'help' for a list of options or 'back' to return to specialization selector"
      input = gets.strip
      case input
        when "help"
          self.selected_spec.show_menu_options
        when "single target rotation"
          self.selected_spec.single_target_rotation
        when "aoe rotation"
          self.selected_spec.aoe_rotation
        when "cooldowns"
          self.selected_spec.cooldowns
        when "back"
          self.selected_spec = nil
      end
    end
  end
  
  def char_class_name 
    self.selected_class.name  
  end
  
  def spec_name
    self.selected_spec.name
  end
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash)
    end
  end
  
end