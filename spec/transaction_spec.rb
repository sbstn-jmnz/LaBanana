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
      expect(@transaction.orders.any?).to be true
      @transaction.orders.each do |order|
        expect(order).to be_instance_of(Integer)
      end
    end
  end
  
  describe 'Instance Methods'
    describe '#update_orders' do
      it "it calls :calculate_left_remainig when there is a remaining on the original order" do
        allow(@order).to receive(:quantity).and_return(2)
        allow(@transaction).to receive(:orders_quantity).and_return(1)
        expect(@transaction).to receive(:calculate_left_remainig)
        expect(@transaction).to receive(:execute_orders)
        @transaction.update_orders(@order, @matching_orders)
      end
      it "it calls :calculate_right_remainig when there is a more quantity than the original order" do
        allow(@order).to receive(:quantity).and_return(1)
        allow(@transaction).to receive(:orders_quantity).and_return(2)
        expect(@transaction).to receive(:execute_orders)
        expect(@transaction).to receive(:calculate_right_remainig)
        @transaction.update_orders(@order, @matching_orders)
      end
    end

    describe "#calculate_left_remaining" do
      it 'adds the correct remainig to the original order' do
      @transaction.calculate_left_remainig(@order, @matching_orders)
      expect(@order.remaining).not_to be nil
      expect(@order.remaining).to be(@order.quantity - sum_quantity(@matching_orders))
    end
  end

    describe "#calculate_right_remaining" do
      it 'adds the correct remainig to the last matching order' do
      @transaction.calculate_right_remainig(@order, @matching_orders)
      expect(@order.remaining).to be_zero
      expect(@matching_orders.last.remaining).not_to be nil
      expect(@order.remaining).to be(@order.quantity - sum_quantity(@matching_orders))
      end
    end

    describe "#execute_orders" do
      it "changes executed and remainig of given orders" do
        @transaction.execute_orders(@matching_orders)
        @matching_orders.each do |order|
          expect(order.remaining).to be_zero
          expect(order.executed).to be true
        end
      end
    end
end