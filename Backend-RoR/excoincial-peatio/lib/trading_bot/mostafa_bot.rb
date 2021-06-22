module TradingBot
  class MostafaBot
    def initialize(*)
      @ask = :eta
      @bid = :afcash
      @member_id = 415
      @market_id = :etaafcash
      @base_volume = 10000
      @duration = 5
      @index_range = 3
      @index_range_array = 0..3
      @set_price = 0.005
      @set_precision = 0.008
      @step = 0.05
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

    def price_in_range(price)
      price > @set_price * ( 1 - @set_precision ) &&
      price < @set_price * ( 1 + @set_precision )
    end

    def process
      @index_range_array = Range.new(0,@index_range)
      while true
        @myAsks = myAsks
        @myBids = myBids
        if @myAsks.size < 15
          make_ask_order
        end

        if @myBids.size < 15
          make_bid_order
        end

        if @myAsks.size > 40
          cancel_order myWasteAsk
        end

        if @myBids.size > 40
          cancel_order myWasteBid
        end

#        puts "price in range #{price_in_range last_price}"
        unless price_in_range last_price
          cancel_all_asks
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
        make_matching_orders

      end
    end

    def make_bid_order
#      return unless price_in_range last_price
#      for i in @index_range_array
#        order = OrderBid.new bid: @bid, ask: @ask, member_id:@member_id, price: last_price*(1 - (@prng.rand(i * @step)).round(6)), volume: @base_volume*(0.1 + @prng.rand(0.9 + i * 0.03)).round(6), market_id: @market_id, ord_type: :limit, state: Order::WAIT
#        Ordering.new(order).submit
#      end
    end

    def make_ask_order
      return unless price_in_range last_price
      for i in @index_range_array
        order = OrderAsk.new bid: @bid, ask: @ask, member_id:@member_id, price: last_price*(1 + (@prng.rand(i * @step)).round(7)), volume: @base_volume*(0.1 + @prng.rand(0.9 + i * 0.03)).round(6), market_id: @market_id, ord_type: :limit, state: Order::WAIT
        Ordering.new(order).submit
      end
    end

    def make_matching_orders
      order = OrderAsk.new bid: @bid, ask: @ask, member_id:@member_id, price: best_sell_price * (
        1 - (
          @prng.rand(
            @index_range *
            @step *
            0.1)
        ).round(7)),
        volume: @base_volume *
          (0.1+@prng.rand(0.9)),
        market_id: @market_id, ord_type: :limit, state: Order::WAIT
      Ordering.new(order).submit unless price_in_range best_sell_price
#      order = OrderBid.new bid: @bid, ask: @ask, member_id:476, price: best_buy_price * (
#        1 + (
#          @prng.rand(
#            @index_range *
#            @step *
#            0.5)
#        ).round(6)),
#        volume: @base_volume *
#          (0.1+@prng.rand(0.9)),
#        market_id: @market_id, ord_type: :limit, state: Order::WAIT
#      Ordering.new(order).submit unless price_in_range best_buy_price
    end

    def cancel_order(order)
      Ordering.new(order).cancel
    end

    def cancel_all_order
      orders = Order.where(member_id: @member_id).with_state(:wait).with_market(@market_id)
      Ordering.new(orders).cancel
    end

    def cancel_all_bids
      orders = OrderBid.where(member_id: @member_id).with_state(:wait).with_market(@market_id)
      Ordering.new(orders).cancel
    end

    def cancel_all_asks
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
