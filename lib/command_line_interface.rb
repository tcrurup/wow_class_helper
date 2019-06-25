class CommandLineInterface

  attr_accessor :status, :selected_class, :selected_spec


  def initialize
    self.class.create_all_classes
    @status = "ready"
    @selected_class = nil
    @selected_spec = nil
  end

  def run
    if @status == "ready"
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
    while self.selected_class.nil? && self.running?
      puts "What class would you like to look at? ('exit' to quit)"
      puts "'quit' to quit, 'show classes' to view all options"
      input = gets.strip
      case input
        when "show classes"
          PlayerClass.print_all_classes
        when "quit"
          self.status = "ended"
        else
          self.selected_class = PlayerClass.find_by_class_name(input)
          puts "invalid option " if self.selected_class.nil?
      end
    end
  end

  def prompt_user_to_select_specialization
    while !self.spec_selected? && self.class_selected? && self.running?

      system('clear')
      puts "What specialization would you like to look at?"
      puts "'quit' to quit, 'back' to select Class"
      puts "-------------------------------------------------"
      # move show_specializations to CLI
      # the object will have to be passed along to the method
      # reduce the body of the method to one line of code
      self.show_specializations

      input = gets.strip.downcase
      case input
        when 'back'
          self.selected_class = nil
        when 'quit'
          self.status = "ended"
        else
          self.selected_spec = self.selected_class.get_spec_by_name(input)
          puts "invalid option " unless spec_selected?
      end
    end
  end

  def show_specializations
    puts selected_class.specializations.collect{ |spec| spec.name }.join(" | ")
  end

  def prompt_user_for_spec_options
    system("clear")
    input = String.new
    until input == "back" || !self.running?
      puts "What would you like to view for the #{self.spec_name} #{self.char_class_name}?"
      puts "Type 'help' for menu options, 'back' to return to specialization selector, or 'quit' to quit"
      input = gets.strip.downcase
      case input
        when "help"
          system('clear')
          self.selected_spec.show_menu_options
        when "single target rotation"
          self.selected_spec.single_target_rotation
        when "aoe rotation"
          self.selected_spec.aoe_rotation
        when "cooldowns"
          self.selected_spec.cooldowns
        when "back"
          self.selected_spec = nil
        when "quit"
          self.status = "ended"
      end
    end
  end

  def spec_selected?
    self.selected_spec != nil
  end

  def running?
    self.status == 'running'
  end

  def class_selected?
    self.selected_class != nil
  end

  def char_class_name
    #Necessary?
    self.selected_class.name
  end

  def spec_name
    #Necessary?
    self.selected_spec.name
  end

  def self.create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash)
    end
  end

end
