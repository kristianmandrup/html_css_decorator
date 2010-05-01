require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HtmlCssDecorator" do
  it "works" do
    doc = Nokogiri::HTML(File.open 'fixtures/test.html')

    # Use Css_Parser (Alan D.)

    cp = CssParser::Parser.new  
    
    file_name = File.dirname(__FILE__) + '/fixtures/my.css'
    cp.load_file!(file_name)    

    @list = {}
    
    cp.each_selector do |sel|       
      doc.css(sel.selector).each do |elem|
        @list[elem.object_id] ||= Rule.new sel.to_s
        @list[elem.object_id].add_rule! sel.to_s       
      end
    end

    doc.css('*').each do |elem|                 
      if @list[elem.object_id]
        @list[elem.object_id].merge_declarations! 
      end
    end
    
    doc.css('*').each do |elem|        
      if @list[elem.object_id]
        puts show(elem, @list[elem.object_id]) 
      end
    end

  end
end    

def show(elem, style)
  #{ }"#{elem.name} #{elem.selectors ? elem.selectors.inspect : 'none' }"
  s = "#{elem.name} : "
  return s if !style.declarations
  style.declarations.each_pair do |key, value|                          
    d = CssParser::Declaration.new key, value[:value], value[:is_important]
    s += d.to_s
  end    
  s
end
