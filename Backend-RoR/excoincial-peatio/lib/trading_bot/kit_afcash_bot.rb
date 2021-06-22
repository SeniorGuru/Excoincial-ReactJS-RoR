module TradingBot
  class KitAfcashBot
    def initialize(*)
      @ask = :kit
      @bid = :afcash
      @member_id = 1
      @market_id = :kitafcash
      @base_volume = 0.002
      @duration = 20
      @index_range = 20
      @index_range_array = 0..20
      @step = 0.01
      @prng = Random.new
    end

    def last_price
      Global[@market_id].ticker[:last]
    end

    def best_buy_price
      Global[@market_id].ticker[:buy]
    end

    def best_sell_price
      Global[@market_id].ticker[:sell]
    end

    def process
      @index_range_array = Range.new(0,@index_range)
      while true
        @myAsks = myAsks
        @myBids = myBids
        if @myAsks.size < 15
          order_make_ask
        end

        if @myBids.size < 15
          order_make_bid
        end

        if @myAsks.size > 40
          order_cancel myWasteAsk
        end

        if @myBids.size > 40
          order_cancel myWasteBid
        end

        sleep (
          @duration /
          [ 1, 1, 1, 1,
           12,18,13,24,
           22,29,30, 4,
           12,15,12, 8,
           24,30, 4, 3,
            1, 2, 1, 1,
            1, 0, 0, 0][
          ((Time.now - Time.now.at_beginning_of_day) / 3600) * @prng.rand(2)]).round(0).to_i
        order_matching_build

      end
    end

    def order_make_bid
      puts @index_range_array
      for i in @index_range_array
        order = OrderBid.new bid: @bid, ask: @ask, member_id:@member_id, price: last_price*(1 - (@prng.rand(i * @step)).round(6)),
          volume: order_estimate_volume(i),
          market_id: @market_id, ord_type: :limit, state: Order::WAIT
        order_submit(order)
      end
    end

    def order_make_ask
      puts @index_range_array
      for i in @index_range_array
        order = OrderAsk.new bid: @bid, ask: @ask, member_id:@member_id, price: last_price*(1 + (@prng.rand(i * @step)).round(6)),
          volume: order_estimate_volume(i),
          market_id: @market_id, ord_type: :limit, state: Order::WAIT
        order_submit(order)
      end
    end

    def order_matching_build
      order = OrderAsk.new bid: @bid, ask: @ask, member_id:@member_id, price: best_sell_price * (
        1 - (
          @prng.rand(
            @index_range *
            @step *
            0.5)
        ).round(6)),
        volume: order_estimate_volume,
        market_id: @market_id, ord_type: :limit, state: Order::WAIT
      order_submit(order)
      order = OrderBid.new bid: @bid, ask: @ask, member_id:@member_id, price: best_buy_price * (
        1 + (
          @prng.rand(
            @index_range *
            @step *
            0.5)
        ).round(6)),
        volume: order_estimate_volume,
        market_id: @market_id, ord_type: :limit, state: Order::WAIT
      order_submit(order)
    end

    def order_estimate_volume(index = 0)
      rand_range = 0.9 + index * 0.03

      (
        order_base_volume_evaluate * ( 0.1 + @prng.rand(rand_range) ).round(6)
      ).round(8)
    end

    def order_base_volume_evaluate
      [
        @base_volume * Currency.find(@ask).upstream_downscale.to_f,
        @base_volume / Currency.find(@bid).upstream_downscale.to_f
      ].min
    end

    def order_submit(order)
      Ordering.new(order).submit
    rescue Account::AccountError => e
      report_exception e
      Rails.logger.debug { "Out of liquidity for " +
        (order.type == "OrderBid" ? order.bid : order.ask).id.upcase +
        " to satisfy volume of " +
        order.volume
      }
    end

    def order_cancel(order)
      Ordering.new(order).cancel
    end

    def order_cancel_all
      orders = Order.where(member_id: @member_id).with_state(:wait).with_market(@market_id)
      Ordering.new(orders).cancel
    end

    def order_bids_cancel_all
      orders = OrderBid.where(member_id: @member_id).with_state(:wait).with_market(@market_id)
      Ordering.new(orders).cancel
    end

    def order_asks_cancel_all
      orders = OrderAsk.where(member_id: @member_id).with_state(:wait).with_market(@market_id)
      Ordering.new(orders).cancel
    end



    def myAsks
      OrderAsk.where(member_id: @member_id).with_state(:wait).with_market(@market_id).order(:price)
    end

    def myBids
      OrderBid.where(member_id: @member_id).with_state(:wait).with_market(@market_id).order(:price)
    end

    def myBestBid
      @myBids.last
    end

    def myWasteBid
      @myBids.first
    end

    def myBestAsk
      @myAsks.first
    end

    def myWasteAsk
      @myAsks.last
    end
  end
end
