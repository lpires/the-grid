require 'workflow'
require 'json'
require './app/agent_factory'
require './app/agent'

class Commander
  attr_accessor :actions
  include Workflow

  workflow do
    state :new do
      event :create, :transitions_to => :awaiting_move
    end
    state :awaiting_move do
      event :clear, :transitions_to => :awaiting_move
      event :move, :transitions_to => :awaiting_move
      event :end_session, :transitions_to => :exit
    end
    state :exit
  end

  def initialize commands_config=nil
    @actions = Hash.new
    default_create_actions
    default_clean_action
    default_show_action
    create_move_actions commands_config unless commands_config.nil? 
  end

  def exec params
    grid, x, y= params[:grid], params[:x], params[:y]
    params[:lost] =false

    if new?
      grid = create!({:x => x, :y=> y})
      return {:x => x, :y=> y , :grid=>grid}
    end
    if awaiting_move?
      grid = move!(params[:key].to_sym, params)
      return {:x => params[:x1], :y=> params[:y1], :grid=>grid, :lost=>params[:lost]}
    end
    {:grid=> grid, :x => x, :y=> y}
  end

  def add command
    create_move_actions [command]
  end

  def create params 
    agent = @actions[:I]

    if agent.valid? params 
      return agent.exec params 
    end
    raise "Can't create map, params must contain x and y"
  end

  def clear params
    @actions[:C].exec params 
  end

  def end_session
  end

  def move command, params
    agent = @actions[command]
    init_params params, agent.set
    if agent.valid? params
      return agent.exec params
    end
    raise "Can't make move, check is all rules pass: #{agent.rules * ', '}"
  end

  private

  def default_create_actions
    min_m, max_n = 1, 250 
    rules = Array.new
    rules << '#{x} >= ' + min_m.to_s
    rules << '#{y} <=' + max_n.to_s
    @actions[:I] = AgentFactory.create(:I, 'create_map', nil, rules, "Creates a new map") 
  end

  def default_clean_action
    @actions[:C] = AgentFactory.create(:C, 'create_map', nil, nil, "Clean map")
  end 

  def default_show_action
    @actions[:S] = AgentFactory.create(:S, 'show_map', nil, nil, "Dispaly map")
  end 

  def create_move_actions config
    config.each do |key, config|
      key = key.to_sym
      set = config['set']
      rules = config['rules']
      method =  config['method']
      description =  config['description']
      @actions[key] = AgentFactory.create(key, method, set, rules, description) 
    end
  end

  private
  def init_params params, sets
    return if params[:grid].nil?
    x = params[:x]
    y = params[:y]
    c = params[:c]
    params[:x0] = x unless params.has_key? :x0
    params[:y0] = y unless params.has_key? :y0
    params[:c0] = c unless params.has_key? :c0

    x = 'params[:x]' if x.nil?
    y = 'params[:y]' if y.nil?
    c = 'params[:c]' if c.nil?

    x0 = 'params[:x0]' if x0.nil?
    y0 = 'params[:y0]' if y0.nil?
    c0 = 'params[:c0]' if c0.nil?

    x1 = 'params[:x1]' if x1.nil?
    y1 = 'params[:y1]' if y1.nil?
    c1 = 'params[:c1]' if c1.nil?

    b = binding
    sets.each do |set|
      s = b.eval "\""+set+"\""
      b.eval s
    end unless sets.nil?
  end
end
