module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base

    # Processes orders and decides what action should be sent to @target
    def call(dax, &block)
      sources = dax.select { |k, _v| k != :target }
      ob = merge_orderbooks(sources, dax[:target].market)
      ob = scale_amounts(ob)

      open_orders = dax[:target].open_orders
      diff = open_orders.get_diff(ob)

      [:buy, :sell].each do |side|
        create = diff[:create][side]
        delete = diff[:delete][side]
        update = diff[:update][side]


        if !create.length.zero?
          order = create.first
          yield Arke::Action.new(:order_create, :target, { order: order })
        elsif !delete.length.zero?
          yield Arke::Action.new(:order_stop, :target, { id: delete.first })
        elsif !update.length.zero?
          order = update.first
          if order.amount > 1e-8
            yield Arke::Action.new(:order_create, :target, { order: order })
          else
            new_amount = open_orders.price_amount(side, order.price) + order.amount
            new_order = Arke::Order.new(order.market, order.price, new_amount, order.side)

            open_orders.price_level(side, order.price).each do |id, _ord|
              yield Arke::Action.new(:order_stop, :target, { id: id })
            end

            yield Arke::Action.new(:order_create, :target, { order: new_order })
          end
        end
        if !create.length.zero?
          @bids = Member.find(3).orders.where(
            market_id: dax[:target].market,
            state: :wait,
            funds_received: 0,
            type: "OrderBid"
          ).order(:price).reject do |o|
            (Time.now - o.created_at) < 1.hours
          end
          @asks = Member.find(3).orders.where(
            market_id: dax[:target].market,
            state: :wait,
            funds_received: 0,
            type: "OrderAsk"
          ).order(price: :desc).reject do |o|
            (Time.now - o.created_at) < 1.hours
          end
          Ordering.new(@asks[0..-50]).cancel
          Ordering.new(@bids[0..-50]).cancel
        end
      end
    end

    def scale_amounts(orderbook)
      ob = Arke::Orderbook.new(orderbook.market)

      [:buy, :sell].each do |side|
        orderbook[side].each do |price, amount|
          ob[side][price] = amount * @volume_ratio
        end
      end

      ob
    end

    def merge_orderbooks(sources, market)
      ob = Arke::Orderbook.new(market)


      sources.each do |_key, source|
        source_book = source.orderbook.clone(market)

#        Arke::Log.debug( "source.market.inspect != market.inspect\n" +
#          source.market.inspect + "!=" + market.inspect +
#          "source_book" + source_book.inspect
#        ) unless source.market.inspect == market.inspect
#        raise fatal.new "CRITICAL ERROR, attempt to merge orderbooks of different markets" unless source.market.inspect == market.inspect
        # discarding 1st level
        source_book[:sell].shift
        source_book[:buy].shift

        ob.merge!(source_book)
      end

      ob
    end
  end
end
