class CommandLineInterface
  
  attr_accessor :status, :current_class
  
  
  def intialize
    @status = "ready"
  end
  
  def run
    self.create_all_classes
    self.status = "running"
    self.interface
  end
  
  def interface 
    system("clear")
    puts "Welcome to the Wow Class Helper"
    while self.status == "running" 
      current_class = PlayerClass.prompt_for_class
      unless current_class.nil?
        current_spec = current_class.prompt_for_spec
      end
    end
  end
  
  def prompt_for_specialization
    
    puts "Which specilization would you like to view?"
    puts "'exit' to go back, 'show specializations' to view all options"
    input = gets.strip
    when "show specializations"
      
    
  end
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash[:name], class_hash[:specializations])
    end
  end
  
end