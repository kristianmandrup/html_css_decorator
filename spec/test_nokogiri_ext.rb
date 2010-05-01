require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class AddOn          
  attr_accessor :str
  
  def initialize(str)
    @str=str
  end
end

describe "HtmlCssDecorator" do
  it "works" do    
    doc = Nokogiri::HTML(File.open 'fixtures/test.html')
    @list = {}
    
    doc.css('*').each do |elem| 
      @list[elem.object_id] = AddOn.new 'hello'
    end

    puts @list.inspect
    
  end
end