module TradingBot
  class EtaAfcashBot < KitAfcashBot
    def initialize(*)
      super
      @ask = :eta
      @bid = :afcash
      @member_id = 1
      @market_id = :etaafcash
      @base_volume = 400
      @duration = 20
      @step = 0.01
      @prng = Random.new
    end
  end
end
