module TradingBot
  class XrpTusdBot < BtcUsdBot
    def initialize(*)
      super
      @ask = :xrp
      @bid = :tusd
      @market_id = :xrptusd
      @step = 0.0002
    end
  end
end
