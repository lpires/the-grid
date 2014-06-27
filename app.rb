require 'rubygems'
require 'sinatra'
require 'rabl'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'
require 'matrix'
require './app/commander'


# Register RABL
Rabl.register!

commander = Commander.new(JSON.parse(File.read('./config/commands.json')))


get '/' do
  erb :index
end

# Send command
put '/commands' do
  command = {}
  [:grid].each do |key|
    unless params[key.to_s].nil?
      command[key] = Matrix.rows eval(params[key.to_s])
    end
  end

  [:x, :y, :x1, :y1].each do |key|
    unless params[key.to_s].nil?
      command[key] = params[key.to_s].to_i
    end
  end

  [:key, :c, :c1].each do |key|
    unless params[key.to_s].nil?
      command[key] = params[key.to_s].to_sym
    end
  end

  p "????????????????????"
  p command
  @grid = commander.exec command

  render :rabl, :'api/commands/update'
end

# List commands
get '/commands' do
	@commands = commander.actions.values
	render :rabl, :'api/commands/index'
end

# Shows command
get '/commands/:id' do |id|
	@command = commander.actions[id.to_sym]
  	render :rabl, :'api/commands/show'
end







