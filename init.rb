#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative('lib/market')
require 'json'

puts 'Procesando ordenes iniciales'
market = Market.new.load_initial_orders

10.times do
  print '......'
  sleep 0.1
end
puts

puts "En este momento hay una oferta de #{market.quantity} bananas"

puts '------------------------------------------------------------'
File.open("output.json","w") do |f|
  f.write(market.to_s.to_json)
end
puts 'Se ha generado el archivo output.json con el resultado'

