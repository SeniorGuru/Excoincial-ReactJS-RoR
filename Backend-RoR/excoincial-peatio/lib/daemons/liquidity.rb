require File.join(ENV.fetch('RAILS_ROOT'), "config", "environment")

require 'binance'
@logger = Rails.logger

@client ||= Binance::Client::REST.new

$running = true
Signal.trap("TERM") do
  $running = false
end
@lastprice = 0
def trend(price)
  return 1 if price.to_d > @lastprice.to_d
  0
end

startTime = Trade.with_market(:xrptusd).last&.created_at.to_i
startTime = 60.days.ago unless startTime > 0

working_market = Market.find :xrptusd
while (startTime < Time.current.to_i - 10)
  startTime = (startTime + 1) * 1000
  lines = @client.klines symbol: :XRPUSDT, interval: '1m', startTime: startTime
  for line in lines
    for i in 1..4
      td = Trade.new price: line[i],
                     volume: line[5].to_d/4,
                     market_id: :xrptusd,
                     ask_member_id: 1,
                     bid_member_id: 1,
                     ask_id:1,
                     bid_id:2,
                     trend: trend(line[i]),
                     funds: line[i].to_d*line[5].to_d/4,
                     created_at: Time.at(line[0]/1000) + i*10.seconds,
                     updated_at: Time.at(line[0]/1000) + i*10.seconds
      td.save
      @lastprice = line[i].to_d
    end
  end
  startTime = lines[-1][6]/1000 + 5.seconds
end

while($running) do
  sleep 5
  price = @client.price(symbol: :XRPUSDT).fetch('price').to_d
  if price > @lastprice
    orders = OrderAsk.where(member_id: 1).with_state(:wait).with_market(working_market)
    Ordering.new(orders).cancel
    for i in 0..5
      order = OrderBid.new bid: :tusd, ask: :xrp, member_id:1, price: price*(1 - i * 0.01), volume: 0.1, market_id: :xrptusd, ord_type: :limit, state: Order::WAIT
      Ordering.new(order).submit
    end
    order = OrderAsk.new bid: :tusd, ask: :xrp, member_id:1, price: price, volume: 0.1, market_id: :xrptusd, ord_type: :limit, state: Order::WAIT
    Ordering.new(order).submit
  elsif price < @lastprice
    orders = OrderBid.where(member_id: 1).with_state(:wait).with_market(working_market)
    Ordering.new(orders).cancel
    for i in 0..5
      order = OrderAsk.new bid: :tusd, ask: :xrp, member_id:1, price: price*(1 + i * 0.01), volume: 0.1, market_id: :xrptusd, ord_type: :limit, state: Order::WAIT
      Ordering.new(order).submit
    end
    order = OrderBid.new bid: :tusd, ask: :xrp, member_id:1, price: price, volume: 0.1, market_id: :xrptusd, ord_type: :limit, state: Order::WAIT
    Ordering.new(order).submit
  else

  end
  @lastprice = price
end
