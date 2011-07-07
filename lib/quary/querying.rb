module Quary
  def query
    ::Quary::Query.new(to_a)
  end

  %w[ where group limit order all ].each do |m|
    module_eval <<-EOF
      def #{m}(*args, &block)
        query.#{m}(*args, &block)
      end
    EOF
  end
end
