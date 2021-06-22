window.MarketTradesUI = flight.component ->
  flight.compose.mixin @, [NotificationMixin]

  @attributes
    defaultHeight: 156
    tradeSelector: 'tr'
    newTradeSelector: 'tr.new'
    allSelector: 'a.all'
    mySelector: 'a.my'
    allTableSelector: 'table.all-trades tbody'
    myTableSelector: 'table.my-trades tbody'
    newMarketTradeContent: 'table.all-trades tr.new div'
    newMyTradeContent: 'table.my-trades tr.new div'
    tradesLimit: 80

  @showAllTrades = (event) ->
    @select('mySelector').removeClass('active')
    @select('allSelector').addClass('active')
    @select('myTableSelector').hide()
    @select('allTableSelector').show()

  @showMyTrades = (event) ->
    @select('allSelector').removeClass('active')
    @select('mySelector').addClass('active')
    @select('allTableSelector').hide()
    @select('myTableSelector').show()

  @bufferMarketTrades = (event, data) ->
    @marketTrades = @marketTrades.concat data.trades

  @clearMarkers = (table) ->
    table.find('tr.new').removeClass('new')
    table.find('tr').slice(@attr.tradesLimit).remove()

  @notifyMyTrade = (trade) ->
    market = gon.market
    return if !@isMine(trade)
    return if trade.market != market.id
    message = gon.i18n.notification.new_trade
      .replace(/%{kind}/g, gon.i18n[if trade.type = 'buy' then 'bid' else 'ask'])
      .replace(/%{id}/g, if (typeof trade.id!="undefined") then trade.id else trade.tid)
      .replace(/%{price}/g, trade.price)
      .replace(/%{volume}/g, if (typeof trade.volume!="undefined") then trade.volume else trade.amount)
      .replace(/%{base_unit}/g, gon.market.ask_unit.toUpperCase())
      .replace(/%{quote_unit}/g, gon.market.bid_unit.toUpperCase())
    @notify message

  @isMine = (trade) ->
    return false if @myTrades.length == 0

    for t in @myTrades
      if (if (typeof trade.id!="undefined") then trade.id else trade.tid) == t.id
        return true
      if (if (typeof trade.id!="undefined") then trade.id else trade.tid) > t.id # @myTrades is sorted reversely
        return false

  @handleMarketTrades = (event, data) ->
    for trade in data.trades
      @marketTrades.unshift trade
      trade.classes = 'new'
      trade.classes += ' mine' if @isMine(trade)
      el = @select('allTableSelector').prepend(JST['templates/market_trade'](trade))

    @marketTrades = @marketTrades.slice(0, @attr.tradesLimit)
    @select('newMarketTradeContent').slideDown('slow')

    setTimeout =>
      @clearMarkers(@select('allTableSelector'))
    , 900

    BookDataTables.tradeTableDes()
    BookDataTables.tradeTable()

  @handleMyTrades = (event, data, notify=true) ->
    for trade in data.trades
      @myTrades.unshift trade
      trade.classes = 'new'

      el = @select('myTableSelector').prepend(JST['templates/my_trade'](trade))
      @select('allTableSelector').find("tr#market-trade-#{trade.tid}").addClass('mine')
      @notifyMyTrade(trade) if notify

    @myTrades = @myTrades.slice(0, @attr.tradesLimit) if @myTrades.length > @attr.tradesLimit
    @select('newMyTradeContent').slideDown('slow')

    setTimeout =>
      @clearMarkers(@select('myTableSelector'))
    , 900

  @after 'initialize', ->
    @marketTrades = []
    @myTrades = []

    @on document, 'trade::populate', (event, data) =>
      @handleMyTrades(event, trades: gon.trades.reverse())
    @on document, 'trade', (event, trade) =>
      @handleMyTrades(event, trades: [trade])

    @on document, 'market::trades', @handleMarketTrades

    @on @select('allSelector'), 'click', @showAllTrades
    @on @select('mySelector'), 'click', @showMyTrades
