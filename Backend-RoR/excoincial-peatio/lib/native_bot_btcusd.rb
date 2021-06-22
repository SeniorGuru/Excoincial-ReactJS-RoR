market = Market.find File.basename(__FILE__, '.*').split('_')[-1]
puts [
  "TradingBot::",
  market.ask_unit.capitalize,
  market.bid_unit.capitalize,
  "Bot"
].join('').constantize.new().process()