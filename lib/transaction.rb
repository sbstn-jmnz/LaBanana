# frozen_string_literal: true

class Transaction
  attr_accessor :orders
  def initialize(order, matching_orders)
    @orders = [order.id, *matching_orders.map(&:id)]
    update_orders(order, matching_orders)
  end

  def update_orders(order, matching_orders)
    if order.quantity > orders_quantity(matching_orders)
      # All matching orders are executed and the original order has a remainig
      execute_orders(matching_orders)
      calculate_left_remainig(order, matching_orders)
    elsif order.quantity < orders_quantity(matching_orders)
      # Original order and all matching orders are executed, except by the last 
      # one which has a remaining
      calculate_right_remainig(order, matching_orders)
      execute_orders(matching_orders << order)
    else
      # Quantities are equal and all orders are executed without remaining
      execute_orders(matching_orders << order)
    end
  end

  def calculate_left_remainig(order, matching_orders)
    order.remaining = order.quantity - orders_quantity(matching_orders)
  end

  def calculate_right_remainig(order, matching_orders)
    last_matching_order = matching_orders.pop
    rest = order.quantity - orders_quantity(matching_orders)
    last_matching_order.remaining = last_matching_order.quantity - rest
  end

   def execute_orders(orders)
    orders.each do |order|
      order.remaining = 0
      order.executed = true
    end
  end

  def orders_quantity(orders)
    orders.inject(0) do |sum, order|
      sum + order.quantity
    end
  end
end
