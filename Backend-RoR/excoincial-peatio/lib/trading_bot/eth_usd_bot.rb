module TradingBot
  class EthUsdBot < BtcUsdBot
    def initialize(*)
      super
      @ask = :eth
      @bid = :usd
      @market_id = :ethusd
      @step = 0.00008
    end
  end
end
