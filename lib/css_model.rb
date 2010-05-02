module CssModel
  attr_accessor :base_path
  
  def extend_elems!
    self.css('*').each do |elem|                 
      elem.extend(Rule)
    end
  end

  def apply_css!     
    puts "apply_css!"
    # Use Css_Parser (Alan D.)
    cp = CssParser::Parser.new  
      
    self.xpath('//link[@rel = "stylesheet"]').each do |stylesheet|
      file_name = base_path + stylesheet['href']
      puts "load stylesheet: #{file_name}"
      cp.load_file!(file_name)      
    end
  
    cp.each_selector do |sel| 
      self.css(sel.selector).each do |elem|
        elem.add_rule! sel.to_s
      end
          
    end

    self.css('*').each do |elem|                 
      elem.merge_declarations!
      elem.pretty_declarations!
    end 
    self
  end
  
end