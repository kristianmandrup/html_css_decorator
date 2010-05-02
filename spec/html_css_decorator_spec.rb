require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HtmlCssDecorator" do
  it "works" do
    doc = Nokogiri::HTML(File.open 'fixtures/test.html')
    doc.extend(CssModel).extend_elems!
    doc.base_path = File.dirname(__FILE__) + "/fixtures/"
    doc.apply_css!
    
    doc.css('*').each do |elem|  
      puts show(elem)
    end

  end
end    

def show(elem)
  s = "#{elem.name} : "
  return s if !elem.declarations
  elem.declarations.each do |decl|                          
    s += decl[1].to_s
  end    
  s
end
