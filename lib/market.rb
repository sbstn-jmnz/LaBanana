# frozen_string_literal: true

require_relative('order')
require 'byebug'

# Market class
# Instances of this class hold the list of orders
# and process them as they arrive.
class Market
  attr_reader :orders, :transactions

  def initialize
    @orders = []
    @transactions = []
  end

  def load_initial_orders(input_file)
    file = File.read(input_file)
    JSON.parse(file)['orders'].each do |order_hash|
      orders << Order.new(order_hash.transform_keys!(&:to_sym))
      try_execute(orders.last)
    end
  end

  def try_execute(order)
    candidate_orders = right_price_orders(order)
    quantity = 0
    matching_orders = []

    return false if candidate_orders.length.zero?

    while candidate_orders.length.positive? && order.quantity >= quantity
      matching_order = candidate_orders.shift
      matching_orders << matching_order
      quantity += matching_order.quantity
    end

    transactions << Transaction.new(order, matching_orders)
  end

  def right_price_orders(order)
    if order.buy?
      oposite_orders(order).select do |candidate|
        candidate.value <= order.value
      end
    elsif order.sell?
      oposite_orders(order).select do |candidate|
        candidate.value >= order.value
      end
    end
  end

  def pending_orders
    orders.reject(&:executed?)
  end

  def oposite_orders(order)
    pending_orders.reject { |candidate| candidate.type == order.type }
  end

end


class Transaction
end
