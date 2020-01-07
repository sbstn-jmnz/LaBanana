# frozen_string_literal: true

require 'order'
require 'json'
require 'byebug'

module Helpers
  # Generates ten ordered by id orders that could
  # match the order
  FIXTURES_FILE = File.dirname(__FILE__) + '/fixtures/input.json'
  def more_than_one_selling_order(order)
    min_volume = order.size
    collection = []
    size = 0
    iterator = 0
    while size < 2 * min_volume && collection.size < 2
      collection << Order.new(
        id: "test_#{iterator}",
        type: 'ask',
        size: Random.rand(min_volume),
        value: order.value
      )
      iterator += 1
    end
    collection
  end

  def selling_order
    order_hash = JSON.parse(File.read(FIXTURES_FILE))['orders'].select do |order_hash|
      order_hash['type'] == 'ask'
    end.first.transform_keys!(&:to_sym)

    Order.new(order_hash)
  end
end
