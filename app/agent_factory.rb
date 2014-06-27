require 'matrix'
require './app/map_action'

module AgentFactory
	

	def self.create key, method, set, rules, description
		callback = Proc.new do |params|
			map = MapAction.send method, params
			while moving_vertical(params) || moving_horizontal(params)

				params[:x] = params[:x0]
				while moving_horizontal(params)
					map = MapAction.send method, params
					(params[:x] > params[:x1]) ? params[:x]-= 1 : params[:x]+= 1 if moving_horizontal(params)
				end
				
				(params[:y] > params[:y1]) ? params[:y]-= 1 : params[:y]+= 1 if moving_vertical(params)
			end
        	map
      	end

		Agent.new key, method, set, rules, description, &callback
	end

	private

	def self.moving_vertical params
		params.has_key?(:y1) && params[:y]-1 != params[:y1]
	end

	def self.moving_horizontal params
		params.has_key?(:x1) && params[:x]-1 != params[:x1]
	end
end