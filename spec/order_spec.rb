# frozen_string_literal: true

require 'order'

describe "Order" do
  describe "#buy?" do
    it 'returns true when order.type is "bid"' do
      expect(Order.new({type: 'bid'}).buy?).to be(true)
    end
  end
end

