require 'nokogiri'
require 'css_parser'
require 'css_model'
require 'yaml'

module CSS
  module Element
    attr_accessor :parser
    attr_accessor :ruleset
    attr_accessor :rules
    attr_accessor :declarations

    def add_rule!(rule)
      # puts "add rule: #{rule.inspect}"
      @parser ||= CssParser::Parser.new
      @declarations = {}  
            
      parser.add_block! rule                 
    end

    def add_declaration!(declaration)
      return if !declaration                     
      @declarations ||= {}  
      dec = declaration.kind_of?(Array) ? declaration[1] : declaration
      # puts "add dec: #{dec.inspect}"        
      declarations[dec.property] = dec.to_text
    end
    alias_method :[]=, :add_declaration!

    def merge_declarations(selector)
      @order = 0
      
      selector.each_declaration do |decl|        
        add_declaration!(decl)
      end
    end

    def merge_style!
      style = attribute('style')        
      if style   
        s = style.to_s + ';'
        # puts "name: #{name}, decl: #{s}, spec: #{99999}"
        selector = CssParser::Selector.new(name, s, 99999)
        merge_declarations(selector)
      end
    end
                                         
    # merge declarations by specificity
    def merge_declarations!   
      !parser and return

      @order = 0
      @declarations ||= {}

      parser.selector_declarations do |sel, decl|
        # puts "decl: #{decl.inspect}"
        add_declaration!(decl)
      end   
    end   

    def duplicate?(decl)
      declarations.select{|d| d.property == decl.property}.empty?         
    end
  end
end 
     
