require 'spec_helper'

describe AgentFactory do 
	describe 'Action - create new map' do
		
		it 'should create a new table 5*6' do
			x_size, y_size, value = 5, 6, :O

			create_map_action = AgentFactory.create(:C, :create_map, nil, nil, nil)
			expect(create_map_action.kind_of? Agent).to be(true)
			map = create_map_action.exec({:key=>:C,:y=>y_size, :x=>x_size, :value=>value})
			expect(map.row_count).to eq(y_size)
			expect(map.column_count).to eq(x_size)
		end

	end

	describe 'Action - show cell' do

		it 'should position the :A on x,y' do
			x, y, map = 2, 3, Matrix.build(6, 5) {:O}

			position_map_action = AgentFactory.create(:S, :show_map, nil, nil, nil)
			expect(position_map_action.kind_of? Agent).to be(true)

      map0= {:grid=>map}
			map = position_map_action.exec(map0)
			expect(map).to eq(map0)
		end
	end

end
