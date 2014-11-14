require_relative './helpers'

DBHelper::create_table!

RECORDS_NUMBER = 300_000

DB.transaction do
  RECORDS_NUMBER.times do |id|
    DBHelper::insert(
      id: id,
      name: "very expensive val #{id}",
      kind:  rand(1..1_000_000),
      value: rand(1..1_000_000) * 0.01
    )
  end
end

puts 'done. total count: '
puts DBHelper::count
