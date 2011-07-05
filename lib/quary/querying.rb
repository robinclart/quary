module Quary
  def query
    ::Qhinary::Query.new(to_a)
  end

  %w[ where limit order sort all each first last size count ].each do |m|
    module_eval <<-EOF
      def #{m}(*args, &block)
        query.#{m}(*args, &block)
      end
    EOF
  end
end
