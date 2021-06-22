module TradingBot
  class EthBtcBot < BtcUsdBot
    def initialize(*)
      super
      @ask = :eth
      @bid = :btc
      @market_id = :ethbtc
      @base_volume *= 0.2
      @step = 0.0001
    end
  end
end
