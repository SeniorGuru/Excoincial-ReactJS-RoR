module APIv2
  class TradingView < Grape::API
    helpers ::APIv2::NamedParams

    namespace 'tradingview' do
      desc 'Returns TradingView Config'
      get :config do
        {
            supports_search: true,
            supports_group_request: false,
            supports_marks: false,
            supports_timescale_marks: false,
            supports_time: true,
            exchanges: [
                {
                    value: 'STOCK',
                    name: 'Excoincial',
                    desc: ''
                }
            ],
            symbols_types: [{
                                name: 'Cryptocurrency',
                                value: 'crypto'
                            }],
            supported_resolutions: [
                '1', '15', '30', # Minutes
                '60', '120', '720', # Hours
                '1D', '3D', # Days
                '1W', # Weeks
                '1M' # Months
            ]
        }
      end


      params do
        requires :symbol, type: String, desc: 'Symbol Name'
      end
      desc 'Returns Symbols'
      get :symbols do
        {
            "name" => params[:symbol],
            "exchange-traded" => "",
            "exchange-listed" => "",
            "timezone" => "Europe/Paris",
            "minmovement" => 1,
            "minmovement2" => 0,
            "pointvalue" => 1,
            "session" => "24x7",
            "has_intraday" => true,
            "has_no_volume" => false,
            "description" => params[:symbol],
            "has_empty_bars" => false,
            "type" => "bitcoin",
            "supported_resolutions" => ["1", "15", "30", "60", "120", "720", "1D", "3D", "1W"],
            "pricescale" => 100000000,
            "ticker" => params[:symbol],
            "force_session_rebuild" => false
        }
      end

      desc 'Returns system time'
      get :time do
        Time.now.to_i
      end

      desc 'Returns history bars'
      params do
        requires :symbol, type: String, desc: 'Symbol Name'
        requires :resolution, type: String, desc: 'resolution'
        requires :from, type: Integer, desc: 'from unix timestamp'
        requires :to, type: Integer, desc: 'to unix timestamp'
      end
      get :history do
        if [
            'ethbtc',
            'xrptusd'
            ].include? params[:symbol]
          bars_bin = BinanceService.get_ohlc(
            params['symbol'],
            params['resolution'], params['from'], params['to'])
          klines = KLineService.new(params[:symbol], resolution_to_period(params[:resolution]))
                               .get_ohlc({:time_from => params[:from], :time_to => params[:to]})
          klines = klines.select {|k| k[5] > 0}
          downscale = ''
          config = YAML.load_file('config/strategy.yaml')
          [Market.find_by_id(params[:symbol])].each do |m|
            downscale = upstream_downscale_factor(m.ask_unit,m.bid_unit,0)*config[params[:symbol]]['volume_ratio']
          end
          bars_exc = convert_klines_to_bars(klines)
          return merge_bars([bars_bin.update(:s => "f" )
            ], downscale) unless bars_exc.present? and bars_exc.instance_of? Hash and bars_exc.values[-1].present?
          return bars_exc unless bars_bin.present? and bars_bin.instance_of? Hash and bars_bin.values[-1].present?
          merge_bars(
            [
              bars_exc.update(:s => "n"),
              bars_bin.update(:s => "f")
            ], downscale)
        elsif [
            'btcusd',
            'ethusd'
            ].include? params[:symbol]
          config = YAML.load_file('config/strategy.yaml')
          bars_bin = BinanceService.get_ohlc(
            config[params[:symbol]]['sources'].each{ |s| s if s['driver'].downcase == 'binance' }.first['market'].downcase,
            params['resolution'], params['from'], params['to'])
          klines = KLineService.new(params[:symbol], resolution_to_period(params[:resolution]))
                               .get_ohlc({:time_from => params[:from], :time_to => params[:to]})
          klines = klines.select {|k| k[5] > 0}
          downscale = ''
          [Market.find_by_id(params[:symbol])].each do |m|
            downscale = upstream_downscale_factor(m.ask_unit,m.bid_unit,0)*config[params[:symbol]]['volume_ratio']
          end
          bars_exc = convert_klines_to_bars(klines)
          return merge_bars([bars_bin.update(:s => "f" )
            ], downscale) unless bars_exc.present? and bars_exc.instance_of? Hash and bars_exc.values[-1].present?
          return bars_exc unless bars_bin.present? and bars_bin.instance_of? Hash and bars_bin.values[-1].present?
          merge_bars(
            [
              bars_exc.update(:s => "n"),
              bars_bin.update(:s => "f")
            ], downscale)
        else
          klines = KLineService.new(params[:symbol], resolution_to_period(params[:resolution]))
                       .get_ohlc({:time_from => params[:from], :time_to => params[:to]})
          klines = klines.select {|k| k[5] > 0}
          if klines.length == 0
            {s: 'no_data'}
          else
            convert_klines_to_bars(klines)
          end
        end
      end

    end


  end
end
