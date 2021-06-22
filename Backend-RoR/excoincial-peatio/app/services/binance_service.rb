require 'binance'
module BinanceService
  TIMEMAPS = {'1'=> '1m', '15'=> '15m', '30'=> '30m', '60'=> '1h', '120'=> '2h', '720'=> '12h', '1D'=> '1d', 'D'=> '1d', '3D'=> '3d', 'W'=> '1w'}
  def self.get_ohlc(symbol, interval, time_from, time_to)
    @@client ||= Binance::Client::REST.new api_key: ENV['binance_api_key'], secret_key: ENV['binance_api_secret']
    lines = @@client.klines symbol: symbol.upcase, interval: TIMEMAPS[interval], limit: 1000, startTime: time_from * 1000, endTime: time_to * 1000
    if lines.length == 0
      {s: 'no_data'}
    else
      t, o, h, l, c, v = lines.transpose
      t = t.map {|mt| mt / 1000}
      {
          s: 'ok', :t => t, :o => o, :h => h, :l => l, :c => c, :v => v
      }
    end
  end
end