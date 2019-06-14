class PageSection
  
  attr_accessor :section_type, :title, :notes, :list
  
  def initialize(elements_array)
    @notes = []
    self.set_values(elements_array)
  end
  
  def set_values(elements_array)
    elements_array.each do |element|
      if element.name == "h1" 
        self.title = element.text
      elsif element.name == "p" && element.text != "" 
        self.notes << element.text
      elsif element.name == "ol" || element.name == "ul"
        self.list = Scraper.scrape_from_element_list(element)
      end
    end
  end
  
  def display
    system('clear')
    puts self.title
    puts "----------------------------"
    puts self.list
    puts ""
    puts "*notes*"
    puts self.notes
    puts "----------------------------"
  end
  
end