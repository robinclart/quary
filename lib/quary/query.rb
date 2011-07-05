module Quary
  class Query < Array
    def initialize(db)
      super
      @conditions = {}
      @limit = nil
      @order = nil
      @reverse = false
    end

    def query
      self
    end
  
    def where(conditions = {})
      @conditions = conditions
      self
    end

    def limit(number)
      @limit = number
      self
    end

    def order(key, direction = :asc)
      @order = key
      @reverse = begin
        case direction
          when :asc then false
          when :desc then true
        end
      end
      self
    end
    alias :sort :order

    def all
      result = select do |e|
        @conditions.all? { |k,v| Regexp.new(v).match(e[k]) }
      end
      result.sort! { |a,b| a[@order] <=> b[@order] } if @order
      result.reverse! if @reverse
      @limit ? result.slice(0, @limit) : result
    end

    def each(*args, &block)
      all.each(*args, &block)
    end

    def first
      all.first
    end

    def last
      all.last
    end

    def size
      all.size
    end
    alias :count :size
  end
end
