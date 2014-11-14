require 'benchmark'
require_relative './helpers'

def request(n)
  DBHelper::sdata.limit(n).to_a
end

Benchmark.bm(7) do |x|
  (10..300).step(10).each do |i|
    n = i * 1_000
    x.report("req #{n}")   { request(n) }
  end
end

