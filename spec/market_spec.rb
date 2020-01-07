# frozen_string_literal: true

require 'market'
require 'json'

describe 'Describing Market' do
  before(:each) do
    @market = Market.new
    @fixtures = File.dirname(__FILE__) + '/fixtures/input.json'
    @market.load_initial_orders(@fixtures)
  end

  describe 'Instance attributes' do
    it 'has an array of Order instances in its :orders atributes' do
      order = instance_double('Order')
      @market.orders << order
      expect(@market.orders).to be_an_instance_of(Array)
    end

    it 'has an array of Transaction instances in its :transactions attributes' do
      transaction = instance_double('Transaction')
      @market.transactions << transaction
      expect(@market.transactions).to be_an_instance_of(Array)
    end
  end

  describe 'Istance methods ' do
    before(:each) do
      @orders_quantity = JSON.parse(File.read(@fixtures))['orders'].length
    end

    describe '#load_initial_orders' do
      it 'loads orders from a json file to its orders attribute' do
        expect(@market.orders.length).to eq @orders_quantity
      end

      it 'tries to execute each order as they arrive form the file' do
        expect(@market).to receive(:try_execute_order).exactly(@orders_quantity).times
        @market.load_initial_orders(@fixtures)
      end

      it 'pushes order objects to orders attributes' do
        expect(@market.orders.sample).to be_an_instance_of(Order)
      end
    end

    describe '#try_execute_order' do
      before(:each) do
        @market = Market.new
      end

      context 'when there is only one order in the market' do
        it 'returns false and does not add any transaction' do
          @market.orders << Order.new({})
          expect(@market.try_execute_order(@market.orders.last)).to be(false)
          expect(@market.transactions.length).to eq(0)
        end
      end

      context 'when there are matching orders' do
        before(:each) do
          [
            { id: 1, user: 'juan', type: 'ask', size: 2.0, value: 1.0 },
            { id: 2, user: 'pedro', type: 'bid', size: 1.5, value: 1.5 }
          ]
            .each { |order_hash| @market.orders << Order.new(order_hash) }
        end

        it 'adds a new transaction to the list' do
          @market.try_execute_order(@market.orders.last)
          expect(@market.transactions.length).to eq(1)
        end

        it 'calls the right_price_and_quantity_orders method to collect matching orders' do
          allow(@market).to receive(:matching_orders).and_return([])
          expect(@market).to receive(:matching_orders)
          @market.try_execute_order(@market.orders.last)
        end
      end
    end

    describe '#pending_orders' do
      it 'rejects ejecuted orders' do
        executed_order = @market.orders.last
        executed_order.executed = true
        expect(@market.pending_orders).not_to include(executed_order)
      end

      it 'returns empty array when there are no pending orders' do
        @market.orders.each { |order| order.executed = true }
        expect(@market.pending_orders).to be_empty
      end
    end

    describe '#pending_opposite_types_orders' do
      it 'calls pending orders' do
        allow(@market).to receive(:pending_orders).and_return([])
        expect(@market).to receive(:pending_orders)
        @market.pending_opposite_types_orders(@market.orders.first)
      end

      it 'rejects orders of the same type' do
        pending_opposite_orders = @market.pending_opposite_types_orders(@market.orders.first)
        expect(pending_opposite_orders.map(&:type)).not_to include(@market.orders.first.type)
      end
    end

    describe '#rigth_price_matching_orders' do
      before(:each) do
        @order = @market.orders.first
        @matching_orders = @market.orders.reject(&:executed).reject { |candidate| candidate.type == @order.type }
      end

      it 'calls pending_oposite_types_orders' do
        allow(@market).to receive(:pending_opposite_types_orders).with(@order).and_return(@matching_orders)
        expect(@market).to receive(:pending_opposite_types_orders)
        @market.pending_opposite_types_orders(@order)
      end

      it 'selects orders with price less or equal when the original order is for buying' do
        test_order = @market.orders.select { |order| order.buy? }.sample
        @market.right_price_matching_orders(test_order).each do |order|
          expect(order.value).to be <= test_order.value
        end
      end

      it 'selects orders with price higher or equal when the original order is for selling' do
        test_order = @market.orders.select { |order| order.sell? }.sample
        @market.right_price_matching_orders(test_order).each do |order|
          expect(order.value).to be >= test_order.value
        end
      end
    end

    describe('#matching orders') do
      before(:each) do
        @order = @market.orders.select(&:buy?).first
        @matching_orders = @market
                           .orders.reject(&:executed)
                           .reject { |candidate| candidate.type == @order.type }
      end

      it 'filters the orders availables to fullfil the original quantity' do
        allow(@market).to receive(:right_price_matching_orders).with(@order)
                                                               .and_return(more_than_one_selling_order(@order))
        expect(@market.matching_orders(@order).length).to be >= more_than_one_selling_order(@order).length
      end

      it 'returns false if there are no matching orders' do
        allow(@market).to receive(:right_price_matching_orders).with(@order).and_return([])
        expect(@market.matching_orders(@order)).to be false
      end
    end

    describe '#to_s' do
      it 'retutns a list with every transaction and every pending order' do
      end
    end
  end
end
