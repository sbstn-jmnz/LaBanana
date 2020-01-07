# frozen_string_literal: true

require 'transaction'

describe 'Describing Transaction' do
  before(:each) do
    @order = selling_order
    @matching_orders = more_than_one_selling_order(@order)
    @transaction = Transaction.new(@order, @matching_orders)
  end

  describe 'Instance Attributes' do
    it 'hash an array of transactions ids' do
      expect(@transaction.orders).to be_instance_of(Array)
    end
  end

  describe 'Instance Methods'
  describe '#buy?' do
  end
end