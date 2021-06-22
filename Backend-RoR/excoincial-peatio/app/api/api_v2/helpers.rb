# encoding: UTF-8
# frozen_string_literal: true

module APIv2
  module Helpers
    extend Memoist

    def authenticate!
      current_user or raise Peatio::Auth::Error
    end

    def deposits_must_be_permitted!
      if current_user.level < ENV.fetch('MINIMUM_MEMBER_LEVEL_FOR_DEPOSIT').to_i
        raise Error.new(text: 'Please, pass the corresponding verification steps to deposit funds.', status: 401)
      end
    end

    def withdraws_must_be_permitted!
      if current_user.level < ENV.fetch('MINIMUM_MEMBER_LEVEL_FOR_WITHDRAW').to_i
        raise Error.new(text: 'Please, pass the corresponding verification steps to withdraw funds.', status: 401)
      end
    end

    def trading_must_be_permitted!
      if current_user.level < ENV.fetch('MINIMUM_MEMBER_LEVEL_FOR_TRADING').to_i
        raise Error.new(text: 'Please, pass the corresponding verification steps to enable trading.', status: 401)
      end
    end

    def current_user
      # JWT authentication provides member email.
      if env.key?('api_v2.authentic_member_email')
        Member.find_by_email(env['api_v2.authentic_member_email'])
      end
    end

    memoize :current_user

    def current_market
      return Market.enabled.find_by_id(params[:market]) unless params[:market] == "vendescrowafcash"
      error!(error: "Operation restricted to officers only.", status: 422) unless vendasity_inscope?
      return Market.find_by_id(params[:market])
    end

    memoize :current_market

    def vendasity_inscope?
        #puts env['api_v2.authentic_scopes']&.split(' ').inspect
        env['api_v2.authentic_scopes']&.split(' ')&.include? 'vendasity'
    end

    def perform_action(withdraw, action)
      withdraw.with_lock do
        case action
          when 'process'
            withdraw.submit!
            # Process fiat withdraw immediately. Crypto withdraws will be processed by workers.
            if withdraw.fiat?
              withdraw.accept!
              if withdraw.quick?
                withdraw.process!
                withdraw.dispatch!
                withdraw.success!
              end
            end
          when 'cancel'
            withdraw.cancel!
        end
      end
    end

    def time_to
      params[:timestamp].present? ? Time.at(params[:timestamp]) : nil
    end

    def build_order(attrs)
      if Currency.find(current_market&.base_unit).escrow?
        raise CreateOrderError, "For ESCROW coin the price must be equal to 1.0" if attrs[:price].to_f != 1.0
        raise CreateOrderError, "ESCROW issuer can only buy, others can only sell" if \
          current_market&.id == "vendescrowafcash" and \
          attrs[:side] == ( ( current_user.email == "info@vendasity.com" ) ? 'buy' : 'sell' )
        raise CreateOrderError, "For ESCROW coin the order type can only be limit" unless \
          ['limit',nil].include? attrs[:ord_type]
      end
      (attrs[:side] == 'sell' ? OrderAsk : OrderBid).new \
        state: ::Order::WAIT,
        member: current_user,
        ask: current_market&.base_unit,
        bid: current_market&.quote_unit,
        market: current_market,
        ord_type: attrs[:ord_type] || 'limit',
        price: attrs[:price],
        volume: attrs[:volume],
        origin_volume: attrs[:volume]
    end

    def create_order(attrs)
      order = build_order(attrs)
      Ordering.new(order).submit
      order
    rescue Account::AccountError => e
      report_exception_to_screen(e)
      raise CreateOrderAccountError, e.inspect
    rescue => e
      report_exception_to_screen(e)
      raise CreateOrderError, e.inspect
    end

    def create_orders(multi_attrs)
      orders = multi_attrs.map(&method(:build_order))
      Ordering.new(orders).submit
      orders
    rescue => e
      report_exception_to_screen(e)
      raise CreateOrderError, e.inspect
    end

    def order_param
      params[:order_by].downcase == 'asc' ? 'id asc' : 'id desc'
    end

    def format_ticker(ticker)
      permitted_keys = %i[buy sell low high open last volume
                            avg_price price_change_percent]

      # Add vol for compatibility with old API.
      formatted_ticker = ticker.slice(*permitted_keys)
                             .merge(vol: ticker[:volume])
      {at: ticker[:at],
       ticker: formatted_ticker}
    end

    RESOULTION_PERIOD_MAP = {
        '1': 1,
        '15': 15,
        '30': 30,
        '60': 60,
        '120': 120,
        '720': 720,
        'D': 1440,
        '1D': 1440,
        '3D': 2880,
        '1W': 10080
    }.as_json

    def resolution_to_period(resolution)
      RESOULTION_PERIOD_MAP[resolution]
    end

    def convert_klines_to_bars(klines = [])
      t, o, h, l, c, v = klines.transpose
      {
          s: 'ok', :t => t, :o => o, :h => h, :l => l, :c => c, :v => v
      }
    end

    def merge_candles(c = [ {:s => "n"} ], downscale = [1], mem_c = nil )
      #puts 'check if sets of keys are equal'
      #puts c.group_by(&:keys).inspect
      return c.detect { |c| c[:s] ==  'n' } unless c.group_by(&:keys).keys.size == 1
      return unless downscale.size > 0
      downscale.each { |d| d = 1 if d.nil? or d.to_f == 0 }
#      puts "downscale.size #{downscale.size} c.size #{c.size} downscale  #{downscale.inspect}"  if c[0][:t]>1562740000 and c[0][:t]<1562750400
      unless downscale.size == c.size
        dg = downscale.group_by { |d| d.to_f != 1 }
        #puts dg.inspect
        dg.each do |k, v|
          #puts "k conditions not processed yet #{k.inspect} #{v.inspect}"
          if dg.size == 1
            downscale = Array.new(c.size)
            puts "dg.size == 1 #{dg.inspect}   k #{k}   new #{downscale}"
            k ?  downscale.each_with_index{ |a, i| downscale[i] = c[i][:s] == 'n' ? 1 : v[0] } : downscale.fill(1)
          else
            if dg.size == 2
              if k == 1
                puts "k.size == 2 and k == 1  #{k.inspect}"
                downscale = Array.new(c.size).each_with_index{ |a, i| a = c[i][:s] == 'n' ? 1 : v[0] }
              else
		# TODO !!!!!!
                puts "k.size == 2 and k != 1  #{k.inspect}"
                return
              end
            else
		# TODO !!!!!!
              return
            end
          end
        end
      end
      #puts 'sets are equal'
      r = Hash.new
      r[:t], r[:l] = c[0][:t], c[0][:l]
      r[:h], r[:v] = 0,0
#      puts c.inspect if c[0][:t]>1562740000 and c[0][:t]<1562750400
      puts c.inspect if c[0][:t]>1562740000 and c[0][:t]<1562750400
      foreign_present = false
      c.select{ |c| c[:s] == 'f' }.each do |n|
        r[:o] = n[:o]&.to_f&.round 8
        r[:c] = n[:c]&.to_f&.round 8
        foreign_present = true
      end
      unless foreign_present
        c.select{ |c| c[:s] == 'n' }.each do |n|
#          puts "#{mem_c.inspect} #{n.inspect}" if mem_c or ( c[0][:t]>1562740000 and c[0][:t]<1562750400)
          r[:o] = (mem_c ? mem_c : n[:o])&.to_f&.round 8
          r[:c] = n[:c]&.to_f&.round 8
        end
      end
      c.each_with_index do |e, i|
        r[:h] = [ r[:o], r[:c], r[:h], e[:h] ]&.reject {|v| v.nil? }&.max_by(&:to_f)&.to_f&.round 8
        r[:l] = [ r[:o], r[:c], r[:l], e[:l] ]&.reject {|v| v.nil? }&.min_by(&:to_f)&.to_f&.round 8
        r[:v] = r[:v]&.to_f + e[:v]&.to_f * downscale[i]&.to_f
      end
      r[:v] = r[:v]&.round 8
      r.except!(:s)
    end

    def merge_bars(a = [], downscale)
# expand sign of data origin array and fill it
      a.delete_if{ |a| a&.keys&.size < 6 }
      #puts a[0..-1].inspect
      return if a.nil?
      as = []
      a.each_with_index do |a, i|
        as[i] = a[:s].last
      end
      #puts as.inspect
      a.each_with_index do |a, i|
        a[:s] = Array.new(a[:v]&.size&.to_i).fill(as[i])
      end
      #puts a.inspect
      a_concat = []
      #puts 
      (
        a.each do |b|
          a_concat.concat(
            b.values.transpose.map do |vs|
              b.keys.zip(vs).to_h
            end
          )
        end
      )
#      puts a_concat.inspect
# remove artifact in order to transpose hash of arrays to array of hashes
      a_klines = []
      mem_c = nil
      a_concat.group_by{ |awt| awt[:t] }.each_with_index do |awt, i|
        a = awt.flatten[1..-1]
#        puts "#{a.inspect} before dowscales assignment"
        downscales_array = Array.new(a&.size&.to_i).fill(1)
        native_only = false
#        puts downscales_array.inspect
        a.each_with_index do |a, i|
#          puts "#{a.inspect} index #{i} inside downscales assigner"
          if a[:s] == 'f'
            native_only = false
            downscales_array[i] = downscale
          end
        end
        kline =  merge_candles(a,downscales_array,mem_c)
        mem_c = native_only ? nil : kline[:c]
        a_klines.push kline unless kline[:v] == 0
      end
#      puts a_klines[0..5].inspect
      if a_klines.length == 0
        return {s: 'no_data'}
      end
      a_klines_sorted = a_klines.sort_by { |k| k[:t] }
#      a_klines_sorted.each{ |k| puts "#{Time.at(k[:t]).utc.to_formatted_s(:short)} #{k}" if k[:t]>1562740000 and k[:t]<1562750400 }
#      puts ({s: 'ok'}.merge a_klines_sorted[0..5].map(&:to_a).flatten(1).reduce({}){|h,(k,v)| (h[k] ||= []) << v; h}).inspect
      {s: 'ok'}.merge a_klines_sorted.map(&:to_a).flatten(1).reduce({}){|h,(k,v)| (h[k] ||= []) << v; h}
    end

    def upstream_downscale_factor(base,quote,price)
      price = ( price.to_f == 0 ) ? ( (Currency.enabled.find_by_id base).price.to_f / (Currency.enabled.find_by_id quote).price.to_f ) : price
      by_base = (Currency.enabled.find_by_id base)&.upstream_downscale&.to_f
      return by_base == 0 ? 1 : by_base unless price.present? and price.nonzero?

      by_quote = (1 / price * (Currency.enabled.find_by_id quote)&.upstream_downscale&.to_f).to_f
      return [by_base, by_quote].min unless [by_base, by_quote].min == 0
      return [by_base, by_quote].max unless [by_base, by_quote].max == 0
      return 1
    end
  end
end
