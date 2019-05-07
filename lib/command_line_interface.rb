class CommandLineInterface
  
  
  def intialize
  
  end
  
  def run
    
    self.create_all_classes
  end
  
  def create_all_classes
    Scraper.scrape_base_classes.each do |class_hash|
      PlayerClass.new(class_hash[:name], class_hash[:specializations])
    end
  end
  
  
end