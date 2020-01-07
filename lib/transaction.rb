# frozen_string_literal: true

class Transaction
  attr_accessor :orders
  def initialize(order, matching_orders)
    @orders = []
  end
end
