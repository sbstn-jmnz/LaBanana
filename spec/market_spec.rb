# frozen_string_literal: true

require 'market'

describe 'Market' do
 
  describe 'attributes' do
    before(:example) do
      @market = Market.new
    end

    it 'has an array of Order instances in its :orders atributes' do
      @market = Market.new
      @market.orders << Order.new
      expect(@market.orders).to be_an_instance_of(Array)
    end

    it 'has an array of Transaction instances in its @transactions attributes' do
      @market = Market.new
      @market.transactions << Transaction.new
      expect(@market.transactions).to be_an_instance_of(Array)
    end
  end

  describe '#to_s' do
  end
end
