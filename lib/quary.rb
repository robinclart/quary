require "quary/version"

class Quary
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

  def from(index)
    @index = index
    self
  end

  def to(index)
    @limit = index - @index
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
      @conditions.all? { |k,v| access(e, k) =~ Regexp.new(v) }
    end
    result = result.sort { |a,b| access(a, @order) <=> access(b, @order) } if @order
    result = result.reverse if @reverse
    result = result.slice(@index, @limit)
    result = result.group_by { |e| access(e, @group) } if @group
    result
  end

  def to_a
    all.to_a
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

  private

  def access(o, sym)
    o.respond_to?(:[]) ? o[sym] : (o.respond_to?(sym) ? o.send(sym) : nil)
  end
end