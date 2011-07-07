module Quary
  class Query
    def initialize(collection = [])
      @collection = collection
      @conditions = {}
      @limit = collection.size
      @order = nil
      @group = nil
      @reverse = false
      @index = 0
    end

    attr_reader :collection

    def inspect
      "#<#{self.class.name} conditions=#{@conditions.inspect}, limit=#{@limit.inspect}, order=#{@order.inspect}, group=#{@group.inspect}, index=#{@index.inspect}>"
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

    def index(number)
      @index = number
      self
    end

    def order(key)
      @order = key
      self
    end

    def reverse
      @reverse = !@reverse
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
      result = result.slice(@index, @limit)
      @group.nil? ? result : result.group_by { |e| e[@group] }
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
