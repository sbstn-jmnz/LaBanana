require 'market'

describe 'Market' do
  describe 'attributes' do
    it 'has an array of Order instances in its :orders atributes' do
      market = Market.new
      market.orders << Order.new
      expect(market.orders).to be_an_instance_of(Array)
    end
  end

  describe "#orders" do
    
  end

  describe "#transactions" do
    
  end

  describe "#to_s" do
    
  end
  
  
  

end