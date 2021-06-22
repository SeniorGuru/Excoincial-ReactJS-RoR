window.MarketSwitchUI = flight.component ->
  @attributes
    table: 'tbody'
    marketGroupName: '.panel-body-head thead span.name'
#    marketGroupItem: '.dropdown-wrapper .dropdown-menu li a'
    marketGroupItem: 'ul.market-list-selection li a'
    marketsTable: '.table.markets'
    marketSearch: '#market_search'

  @switchMarketGroup = (event, item) ->
    item = $(event.target).closest('a')
    name = item.data('name')

    if name is 'all'
      $('.markets-toggle').removeClass('hide')
    else
      $('.markets-toggle').addClass('hide')
      $('.markets-toggle[data-quote-unit="' + name + '"]').removeClass('hide')
#      $('.markets-toggle[data-base-unit="' + name + '"]').removeClass('hide')

    @select('marketGroupItem').removeClass('active')
    item.addClass('active')

    @select('marketGroupName').text item.find('span').text()



#    $('.markets-toggle').addClass('hide')

#    $('.markets-toggle[data-quote-unit="' + gon.market.bid_unit + '"]').removeClass('hide')

  @searchMarket = (event) ->
    updateBySearch = () ->
      term = $('#market_search').val()
      if term.length
        $('.markets-toggle').addClass('hide')
        select_name = '.markets-toggle[data-base-unit*="' +term+ '"]'
        $(select_name).removeClass('hide')
      else
        name = $('#market_list > ul > li.active > a').data('name')
        if name is 'all'
          $('.markets-toggle').removeClass('hide')
        else
        $('.markets-toggle').addClass('hide')
        $('.markets-toggle[data-quote-unit="' + name + '"]').removeClass('hide')
    setTimeout updateBySearch, 100



  @updateMarket = (select, ticker) ->
    trend = formatter.trend ticker.last_trend
    select.find('td.price a')
      .attr('title', ticker.last)
      .html("<span>#{formatter.ticker_price(ticker.last,6)}</span>")
      #.text("<span>#{ticker.last}</span>")

    p1 = parseFloat(ticker.open)
    p2 = parseFloat(ticker.last)
    trend = formatter.trend(p1 <= p2)
#    select.find('td.change').html("<a><span class='#{trend}'>#{formatter.price_change(p1, p2)}%</span></a>")
    if p1 <= p2
      select.find('td.change a')
        .html("<span class='#{trend}'><i class=\"fa fa-arrow-up\"
                                            aria-hidden=\"true\"></i></span>#{formatter.price_change(p1, p2)}%")
    else
      select.find('td.change a')
        .html("<span class='#{trend}'><i class=\"fa fa-arrow-down\"
                                            aria-hidden=\"true\"></i></span>#{formatter.price_change(p1, p2)}%")

    #select.find('td.vol a').text("#{ticker.volume}")
    select.find('td.vol a')
      .attr('title', ticker.volume)
      .html("<span>#{formatter.ticker_price(ticker.volume,8)}</span>")


  @refresh = (event, data) ->
    table = @select('table')
    for ticker in data.tickers
      @updateMarket table.find("tr#market-list-#{ticker.market}"), ticker.data

    table.find("tr#market-list-#{gon.market.id}").addClass 'highlight'

  @after 'initialize', ->
    @on document, 'market::tickers', @refresh
    @on @select('marketGroupItem'), 'click', @switchMarketGroup
    @on @select('marketSearch'), 'keydown', @searchMarket

    @select('table').on 'click', 'tr', (e) ->
      unless e.target.nodeName == 'I'
        window.location.href = window.formatter.market_url($(@).data('market'))

    @.hide_accounts = $('tr.hide')
    $('.view_all_accounts').on 'click', (e) =>
      $el = $(e.currentTarget)
      if @.hide_accounts.hasClass('hide')
        $el.text($el.data('hide-text'))
        @.hide_accounts.removeClass('hide')
      else
        $el.text($el.data('show-text'))
        @.hide_accounts.addClass('hide')

    $('.markets-toggle').addClass('hide')
    $('.markets-toggle[data-quote-unit="' + gon.market.bid_unit + '"]').removeClass('hide')
