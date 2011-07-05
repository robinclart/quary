module Quary
  class Query
    def initialize(collection = [])
      @collection = collection
      @conditions = {}
      @limit = nil
      @order = nil
      @group = nil
      @reverse = false
    end

    attr_reader :collection

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

    def group(key)
      @group = key
      self
    end

    def all
      result = @collection.select do |e|
        @conditions.all? { |k,v| Regexp.new(v).match(e[k]) }
      end
      result.sort! { |a,b| a[@order] <=> b[@order] } if @order
      result.reverse! if @reverse
      result = result.group_by { |e| e[@group] } if @group
      @limit ? result.slice(0, @limit) : result
    end
    alias :to_a :all

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
