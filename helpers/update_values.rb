require_relative './helpers'
require 'time'

loop do
  [1, 2, 3, 4, 10, 100_000, 200_000, 404].each do |id|
    DBHelper::update(id, name: "#{id} was updated #{Time.now}")
  end
  print '.'
  sleep 5
end
