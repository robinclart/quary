require "quary"

module Quaryable
  def query
    ::Quary.new(to_a)
  end

  %w[ where group limit from to order all ].each do |m|
    module_eval <<-EOF
      def #{m}(*args, &block)
        query.#{m}(*args, &block)
      end
    EOF
  end
end
