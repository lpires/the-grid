require 'spec_helper'

describe Agent do 

	it 'should execute action' do
		test_params = {:flag => false}
		agent = Agent.new :test, nil, nil, nil, nil do |params|
			params[:flag] = true
		end 
		agent.exec(test_params)
		expect(test_params[:flag]).to be(true)
	end
	
end