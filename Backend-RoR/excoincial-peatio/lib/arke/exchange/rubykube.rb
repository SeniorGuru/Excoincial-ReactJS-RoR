module Arke::Exchange
  # This class holds Rubykube Exchange logic implementation
  class Rubykube < Base

    # Takes config (hash), strategy(+Arke::Strategy+ instance)
    # * +strategy+ is setted in +super+
    # * creates @connection for RestApi
    def initialize(config)
      super

      @current_user = Member.find 3
      @current_market = Market.find config['market'].downcase
      # @connection = Faraday.new("#{config['host']}/api/v2") do |builder|
      #   # builder.response :logger
      #   builder.response :json
      #   builder.adapter :em_synchrony
      # end

      @current_user.orders.active.where(market_id: config['market'].downcase).each do |order|
        @open_orders.add_order(Arke::Order.new(@market, order.price.to_f, order.volume.to_f, order.type == "OrderAsk" ? :sell : :buy), order.id)
      end

    end

    # Ping the api
    def ping
      # @connection.get '/barong/identity/ping'
    end

    # Takes +order+ (+Arke::Order+ instance)
    # * creates +order+ via RestApi
    def create_order(order)
      # response = post(
      #   'peatio/market/orders',
      #   {
      #     market: order.market.downcase,
      #     side:   order.side.to_s,
      #     volume: order.amount,
      #     price:  order.price
      #   }
      # )

      return if order.amount < 1e-8
      od = build_order(order)
      return if od.nil?

#      Arke::Log.debug "Skip order creation #{od.to_json}\n#{order.inspect}"
      Ordering.new(od).submit
      @open_orders.add_order(order, od.id) if od.id
      Arke::Log.debug "Order created #{od.to_json}"

      # @open_orders.add_order(order, response.env.body['id']) if response.env.status == 201 && response.env.body['id']

      # response
    end

    # Takes +order+ (+Arke::Order+ instance)
    # * cancels +order+ via RestApi
    def stop_order(id)
      # response = post(
      #   "peatio/market/orders/#{id}/cancel"
      # )
      #

      order = @current_user.orders.find id
      Ordering.new(order).cancel
      @open_orders.remove_order(id)

      # response
    end

    def upstream_downscale_factor(base,quote,price)
      by_base = (Currency.enabled.find_by_id base)&.upstream_downscale&.to_f
      return by_base == 0 ? 1 : by_base unless price.present? and price.nonzero?

      by_quote = (1 / price * (Currency.enabled.find_by_id quote)&.upstream_downscale&.to_f).to_f
      return [by_base, by_quote].min unless [by_base, by_quote].min == 0
      return [by_base, by_quote].max unless [by_base, by_quote].max == 0
      return 1
    end

    def strategy_downscale_factor(market)
      @strategy_config = YAML.load_file("#{Rails.root}/config/strategy.yaml")
      price = Trade.avg_h24_price(market)
      price ||= 0
      upstream_downscale_factor(market.ask_unit,market.bid_unit,price) *
      @strategy_config.fetch(market.id).fetch("volume_ratio") /
        @strategy_config.fetch(market.id).fetch("target").fetch("rate_limit")
    end

    private

    def build_order(attrs)
      Arke::Log.debug "Preparing order for base_unit #{@current_market&.base_unit.inspect}"
      Arke::Log.debug "Preparing order with attrs #{attrs.inspect}"
      downscale = upstream_downscale_factor(@current_market&.base_unit,@current_market&.quote_unit,attrs.price&.to_f)
      downscaled_amount = (Currency.find(@current_market&.base_unit).fiat? ? '%.2f' : '%.8f') % (attrs.amount.to_f * downscale)
      Arke::Log.debug "Preparing order with downscaled_amount #{downscaled_amount} for downscale rate #{downscale}"
      return unless downscaled_amount.to_f > 0
      (attrs.side == :sell ? OrderAsk : OrderBid).new \
          state:         ::Order::WAIT,
          member:        @current_user,
          ask:           @current_market&.base_unit,
          bid:           @current_market&.quote_unit,
          market:        @current_market,
          ord_type:      'limit',
          price:         attrs.price,
          volume:        downscaled_amount,
          origin_volume: downscaled_amount
    end

    # Helper method to perform post requests
    # * takes +conn+ - faraday connection
    # * takes +path+ - request url
    # * takes +params+ - body for +POST+ request
    def post(path, params = nil)
      response = @connection.post do |req|
        req.headers = generate_headers
        req.url path
        req.body = params.to_json
      end
      Arke::Log.fatal(build_error(response)) if response.env.status != 201
      response
    end

    # Helper method, generates headers to authenticate with +api_key+
    def generate_headers
      nonce = Time.now.to_i.to_s
      {
        'X-Auth-Apikey' => @api_key,
        'X-Auth-Nonce' => nonce,
        'X-Auth-Signature' => OpenSSL::HMAC.hexdigest('SHA256', @secret, nonce + @api_key),
        'Content-Type' => 'application/json'
      }
    end
  end
end
