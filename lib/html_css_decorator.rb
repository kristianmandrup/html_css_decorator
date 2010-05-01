require 'nokogiri'
require 'css_parser'

require 'selectors'
require 'yaml'

class Rule
  attr_accessor :parser
  attr_accessor :ruleset
  attr_accessor :rules
  attr_accessor :declarations

  def initialize(rule) 
    @parser ||= CssParser::Parser.new
    add_rule!(rule)
  end

  def add_rule!(rule)
    parser.add_block! rule        
  end

  def add_declaration!(property, value)
    if value.nil? or value.empty?
      @declarations.delete(property)
      return
    end

    value.gsub!(/;\Z/, '')
    is_important = !value.gsub!(CssParser::IMPORTANT_IN_PROPERTY_RX, '').nil?
    property = property.downcase.strip
    @declarations[property] = {
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

                                           
  # merge declarations by specificity
  def merge_declarations!   
    !parser and return

    @order = 0
    @declarations ||= {}
  
    parser.each_selector_sorted(:all, :order => :asc) do |sel|        
      sel.declarations.each do |dec|
        dec.gsub! /"/, ''
        dec.gsub! /\[/, ''
        dec.gsub! /\]/, ''

        decs = dec.split(',')
        decs.each do |d| 
          parse_declarations!(d)              
        end
      
      end
    end             
  end   

  def duplicate?(decl)
    declarations.select{|d| d.property == decl.property}.empty?         
  end
end 
     
