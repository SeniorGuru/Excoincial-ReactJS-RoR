module TradingBot
  class EtaEthBot < KitAfcashBot
    def initialize(*)
      super
      @ask = :eta
      @bid = :eth
      @member_id = 3
      @market_id = :etaeth
      @base_volume = 300
      @duration = 20
      @index_range = 40
      @step = 0.008
      @prng = Random.new
    end
  end
end
