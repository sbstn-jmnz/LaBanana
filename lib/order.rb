# frozen_string_literal: true

# Instances of this class are single orders placed by
# users as they use the program or loaded from the input.json
# file
class Order
  attr_reader :type, :value, :size, :id
  attr_accessor :executed, :remaining

  def initialize(order_hash)
    @id = order_hash[:id]
    @type = order_hash[:type]
    @size = order_hash[:size]
    @value = order_hash[:value]
    @executed = false
    @remaining = nil
  end

  def buy?
    type == 'bid'
  end

  def sell?
    !buy?
  end

  def executed?
    executed
  end

  def quantity
    remaining || size
  end
end
