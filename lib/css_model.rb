module CSS
  module Model  
    
    def self.apply_to(doc, options = {})
      doc.decorators(Nokogiri::XML::Element) << ::CSS::Element
      doc.decorate!             
      doc.extend(::CSS::Model)
      doc.css_path options[:css_path] if options[:css_path]
      doc.apply_css!(options)
      doc      
    end
    
    attr_writer :css_path
  
    def css_path(path = nil)    
      return @css_path if !path 
      @css_path = path
      self
    end
  
    def apply_css!(options = {})     
      # Use Css_Parser (Alan D.)
      cp = CssParser::Parser.new  
      
      self.xpath('//link[@rel = "stylesheet"]').each do |stylesheet|
        file_name = css_path + stylesheet['href']
        puts "load stylesheet: #{file_name}" if options[:verbose]
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
end