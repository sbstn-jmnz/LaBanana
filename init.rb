#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative('lib/market')
require 'byebug'

puts 'Procesando ordenes iniciales'
market = Market.new.load_initial_orders
10.times do
  print '......'
  sleep 0.1
end
puts

puts "En este momento hay una oferta de #{market.quantity} bananas"

puts '------------------------------------------------------------'

puts 'Quieres comprar o vender bananas?'

