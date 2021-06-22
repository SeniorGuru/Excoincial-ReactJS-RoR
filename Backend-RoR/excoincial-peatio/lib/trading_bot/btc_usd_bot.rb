module TradingBot
  class BtcUsdBot < KitAfcashBot
    def initialize(*)
      super
      @ask = :btc
      @bid = :usd
      @member_id = 5
      @market_id = :btcusd
      @base_volume = 0.005
      @duration = 5
      @index_range = 5
      @index_range_array = 0..5
      @step = 0.0002
      @prng = Random.new
    end
  end
end
