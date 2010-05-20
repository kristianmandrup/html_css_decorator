require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HtmlCssDecorator" do
  it "works" do
    doc = Nokogiri::HTML(File.open 'fixtures/test.html')    
    doc = CSS::Model.apply_to(doc, :css_path => File.dirname(__FILE__) + "/fixtures/")

    # selector = CssParser::Selector.new('table', 'margin: 0px; padding: 0px;', 99999)    
    # puts selector.inspect
        
    doc.css('*').each do |elem|  
      puts show(elem) if elem.declarations
      # puts elem if elem.attribute('style')
    end
  end
end    

def show(elem)
  s = "Tag: #{elem.name}\n"
  return s if !elem.declarations
  elem.declarations.each do |decl|
    s += decl[1].to_s
  end    
  s
end
