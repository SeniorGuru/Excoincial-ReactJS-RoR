module TradingBot
  class HotEthBot < BtcUsdBot
    def initialize(*)
      super
      @ask = :hot
      @bid = :eth
      @market_id = :hoteth
      @step = 0.0002
    end
  end
end
