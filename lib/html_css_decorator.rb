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
      @parser ||= CssParser::Parser.new
      @declarations = {}
      parser.add_block! rule        
    end

    def add_declaration!(property, value)
      if value.nil? or value.empty?
        declarations.delete(property)
        return
      end

      value.gsub!(/;\Z/, '')
      is_important = !value.gsub!(CssParser::IMPORTANT_IN_PROPERTY_RX, '').nil?
      property = property.downcase.strip
      declarations[property] = {
        :value => value, :is_important => is_important, :order => @order += 1
      }
    end
    alias_method :[]=, :add_declaration!

    def parse_declarations!(block) # :nodoc: 
      return unless block
      block.gsub!(/(^[\s]*)|([\s]*$)/, '')
      decs = block.split(/[\;$]+/m)
      decs.each do |decs|
        if matches = decs.match(/(.[^:]*)\:(.[^;]*)(;|\Z)/i)              
          property, value, end_of_declaration = matches.captures

          add_declaration!(property, value)          
        end
      end
    end  

    def pretty_declarations!
      !declarations and return
      puts "before: #{declarations.inspect}"
      pretty = {}
      declarations.each_pair do |key, value|                          
        pretty[key] = CssParser::Declaration.new(key, value[:value], value[:is_important])
      end    
      @declarations = pretty    
      puts "after: #{declarations.inspect}"    
      declarations    
    end
                                         
    # merge declarations by specificity
    def merge_declarations!   
      !parser and return

      @order = 0
      @declarations ||= {}

      parser.selector_declarations do |sel, decl|
        parse_declarations!(decl)
      end
    end   

    def duplicate?(decl)
      declarations.select{|d| d.property == decl.property}.empty?         
    end
  end
end 
     
