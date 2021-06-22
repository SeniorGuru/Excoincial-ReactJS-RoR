module TradingBot
  class HotUsdBot < BtcUsdBot
    def initialize(*)
      super
      @ask = :hot
      @bid = :usd
      @market_id = :hotusd
      @step = 0.0002
    end
  end
end
