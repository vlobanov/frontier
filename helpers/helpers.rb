require 'rubygems' 
require 'bundler/setup'
require 'sequel'

$: << File.expand_path("#{__FILE__}/..")

require 'db'

Dir["./lib/**/*.rb"].each { |f| require f }
