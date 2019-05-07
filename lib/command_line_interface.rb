class CommandLineInterface
  
  
  def intialize
  
  end
  
  def run
    
    self.create_all_classes
  end
  
  def create_all_classes
    classes = Scraper.scrape_base_classes
  end
  
  
end