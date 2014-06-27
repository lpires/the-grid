class Agent
	attr_accessor :key, :method, :set, :rules, :description

	def initialize key, method, set, rules, description, &block
		@key = key
		@method = method
		@set = set
		@rules = rules
		@description = description
		@block = block
	end

	def exec params
    params[:exec] = false
    if valid? params
		  return @block.call(params)
    end
	end

	def valid? params
		return false if params.empty?
		flag = true

		b = binding
		params.each do |variable, value|
      b.eval "#{variable} = '#{value}'" if value.kind_of?(String)
			b.eval "#{variable} = #{value}" if value.kind_of?(Fixnum)
			b.eval "#{variable} = :#{value}" if value.kind_of?(Symbol)
    end

		return true if @rules.nil?
		@rules.each do |rule|

			rule = b.eval "\""+rule+"\""
			flag = flag && b.eval(rule)
		end
		flag
	end
end