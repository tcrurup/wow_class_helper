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
      
      current_class = PlayerClass.prompt_user_to_select_class
      unless current_class.nil?
        
        current_spec = current_class.prompt_user_to_select_specialization
        unless current_spec.nil?
        
        current_spec.menu_prompt
        end
      end
    end
  end
  
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash[:name], class_hash[:specializations])
    end
  end
  
end