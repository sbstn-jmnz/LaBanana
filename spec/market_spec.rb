# frozen_string_literal: true

require 'market'
require 'json'

describe 'Market' do
  before(:context) do
    @fixtures = File.dirname(__FILE__) + '/fixtures/input.json'
    @market = Market.new
    @market.load_initial_orders(@fixtures)
  end

  describe '#load_initial_orders' do
    before(:context) do
      @orders_quantity = JSON.parse(File.read(@fixtures))['orders'].length
    end

    it 'loads orders from a json file to its orders attribute' do
      expect(@market.orders.length).to eq @orders_quantity
    end

    it 'tries to execute each order as they arrive form the file' do
      expect(@market).to receive(:try_execute).exactly(@orders_quantity).times
      @market.load_initial_orders(@fixtures)
    end

    it 'pushes order objects to orders attributes' do
      expect(@market.orders.sample).to be_an_instance_of(Order)
    end
  end

  describe 'attributes' do
    it 'has an array of Order instances in its :orders atributes' do
      expect(@market.orders).to be_an_instance_of(Array)
    end

    it 'has an array of Transaction instances in its :transactions attributes' do
      @market.transactions << Transaction.new
      expect(@market.transactions).to be_an_instance_of(Array)
    end
  end

  describe '#try_execute' do
    before(context) do
      @market = Market.new
    end

    context 'when there is only one order in the market' do
      it 'returns and does not add any transaction' do
        @market.orders << Order.new({})
        @market.try_execute(@market.orders.last)
        expect(@market.transactions.length).to eq(0)
      end
    end

    context 'when there are oposite orders' do
      before(:each) do
        order_a = { "id": 1, "user": 'juan', "type": 'ask', "size": 2.0, "value": 1.0 }
        order_b = { "id": 2, "user": 'pedro', "type": 'bid', "size": 1.5, "value": 1.5 }
        @market.orders << Order.new(order_a.transform_keys(&:to_sym))
        @market.orders << Order.new(order_b.transform_keys(&:to_sym))
      end

      it 'adds a new transaction to the list' do
        @market.try_execute(@market.orders.last)
        expect(@market.transactions.length).to eq(1)
      end

      it 'calls the right_price_orders to fulfill the original' do
        allow(@market).to receive(:right_price_orders).and_return([])
        expect(@market).to receive(:right_price_orders)
        @market.try_execute(@market.orders.last)
      end
    end
  end

  describe '#to_s' do
  end
end
