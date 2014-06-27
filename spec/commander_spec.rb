require 'spec_helper'

describe Commander do
	let(:conf) do
		 JSON.parse(File.read('./config/commands.json'))
  end
  before do
    @commander = Commander.new conf
  end

  it 'should have a new state' do
    commander = Commander.new conf
    expect(commander.new?).to be(true)
    expect(commander.awaiting_move?).to be(false)
    expect(commander.exit?).to be(false)
  end

  describe '#create!' do
    it 'should have a awaiting move state' do
      commander = Commander.new conf
      commander.create!({:x=>5, :y=>6})
      expect(commander.new?).to be(false)
      expect(commander.awaiting_move?).to be(true)
      expect(commander.exit?).to be(false)
    end

    it 'should have a awaiting move state' do
      commander = Commander.new conf
      commander.create!({:x=>5, :y=>6})
      expect(commander.new?).to be(false)
      expect(commander.awaiting_move?).to be(true)
      expect(commander.exit?).to be(false)
    end
  end

  describe '#exec' do
    it 'Sample 1' do
      msg = {:key=>:C, :x=>5, :y=>3}
      response = @commander.exec(msg)
      expect(response[:x]).to be(5)
      expect(response[:y]).to be(3)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :P
      msg[:x1]= 1
      msg[:y1]= 1
      msg[:c1]= :E
      response = @commander.exec(msg)
      expect(response[:x]).to be(1)
      expect(response[:y]).to be(1)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :E, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :R
      response = @commander.exec(msg)
      expect(response[:x]).to be(1)
      expect(response[:y]).to be(1)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :S, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :F
      response = @commander.exec(msg)
      expect(response[:x]).to be(1)
      expect(response[:y]).to be(0)
      expect(response[:grid]).to eql(Matrix[[:O, :S, :O, :O, :O], [:O, :S, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :R
      response = @commander.exec(msg)
      p response
      expect(response[:x]).to be(1)
      expect(response[:y]).to be(0)
      expect(response[:grid]).to eql(Matrix[[:O, :W, :O, :O, :O], [:O, :S, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :F
      response = @commander.exec(msg)
      expect(response[:x]).to be(2)
      expect(response[:y]).to be(0)
      expect(response[:grid]).to eql(Matrix[[:O, :W, :W, :O, :O], [:O, :S, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :R
      response = @commander.exec(msg)
      expect(response[:x]).to be(2)
      expect(response[:y]).to be(0)
      expect(response[:grid]).to eql(Matrix[[:O, :W, :N, :O, :O], [:O, :S, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :F
      response = @commander.exec(msg)
      expect(response[:x]).to be(2)
      expect(response[:y]).to be(1)
      expect(response[:grid]).to eql(Matrix[[:O, :W, :N, :O, :O], [:O, :S, :N, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :R
      response = @commander.exec(msg)
      expect(response[:x]).to be(2)
      expect(response[:y]).to be(1)
      expect(response[:grid]).to eql(Matrix[[:O, :W, :N, :O, :O], [:O, :S, :E, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :F
      response = @commander.exec(msg)
      expect(response[:x]).to be(1)
      expect(response[:y]).to be(1)
      expect(response[:grid]).to eql(Matrix[[:O, :W, :N, :O, :O], [:O, :E, :E, :O, :O], [:O, :O, :O, :O, :O]])
      expect(response[:grid][1,1]).to be(:E)
    end

    it 'Sample 2' do
      msg = {:key=>:C, :x=>5, :y=>3}
      response = @commander.exec(msg)
      expect(response[:x]).to be(5)
      expect(response[:y]).to be(3)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :P
      msg[:x1]= 3
      msg[:y1]= 2
      msg[:c1]= :N
      response = @commander.exec(msg)
      expect(response[:x]).to be(3)
      expect(response[:y]).to be(2)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O], [:O, :O, :O, :N, :O]])

      msg = response
      msg[:key]= :F
      response = @commander.exec(msg)
      expect(response[:x]).to be(3)
      expect(response[:y]).to be(3)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O], [:O, :O, :O, :N, :O]])
      expect(response[:lost]).to be(true)
    end

    it 'Sample 3' do
      msg = {:key=>:C, :x=>5, :y=>3}
      response = @commander.exec(msg)
      expect(response[:x]).to be(5)
      expect(response[:y]).to be(3)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O]])

      msg = response
      msg[:key]= :P
      msg[:x1]= 0
      msg[:y1]= 3
      msg[:c1]= :W
      response = @commander.exec(msg)
      expect(response[:x]).to be(0)
      expect(response[:y]).to be(3)
      expect(response[:grid]).to eql(Matrix[[:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O], [:O, :O, :O, :O, :O]])

    end
  end

	it 'should have a exit state' do
		commander = Commander.new conf
		commander.create!({:x=>5, :y=>6})
		commander.end_session!
		expect(commander.new?).to be(false)
		expect(commander.awaiting_move?).to be(false)
		expect(commander.exit?).to be(true)
	end
end