module CssParser
  class SelectorSet
    include Enumerable

    attr_reader :selectors

    def <<(selector)
      selectors << selector      
    end

    def each
      @selectors.each { |sel| yield sel }
    end

    def empty?
      selectors.empty?
    end      

    def initialize
      @selectors = []
    end  
  end
end
