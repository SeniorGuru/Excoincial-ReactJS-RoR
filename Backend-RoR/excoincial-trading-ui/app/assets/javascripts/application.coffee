#= require es5-shim.min
#= require es5-sham.min
#= require jquery
#= require jquery_ujs
#= require jquery.mousewheel
#= require jquery-timing.min
#= require jquery.nicescroll.min
#
#= require bootstrap
#= require bootstrap-switch.min
#
#= require moment
#= require bignumber
#= require underscore
#= require cookies.min
#= require flight.min
#= require ./lib/sfx
#= require ./lib/notifier
#= require ./lib/ranger_events_dispatcher
#= require ./lib/ranger_connection
#= require highstock
#= require_tree ./highcharts/
#= require_tree ./helpers
#= require_tree ./component_mixin
#= require_tree ./component_data
#= require_tree ./component_ui
#= require_tree ./templates
#= require_self
#= require ./tv-chart-widget-init
$ ->
  window.notifier = new Notifier()
  notifier.switch(event, 'true')
  BigNumber.config(ERRORS: false)
  HeaderUI.attachTo('.coins-trade-info')
  AccountSummaryUI.attachTo('#account_summary')
  AccountConsolidatedUI.attachTo('#account_consolidated')
  AccountBalanceUI.attachTo('#account_balance')
  FloatUI.attachTo('.float')
  KeyBindUI.attachTo(document)
#  AutoWindowUI.attachTo(window)
  PlaceOrderUI.attachTo('#bid_entry')
  PlaceOrderUI.attachTo('#ask_entry')
  OrderBookUI.attachTo('#order_book')
  DepthUI.attachTo('#depths_wrapper')
  MyOrdersUI.attachTo('#my_orders')
  MarketTickerUI.attachTo('#ticker')
  MarketSwitchUI.attachTo('#market_list_wrapper')
  MarketTradesUI.attachTo('#market_trades_wrapper')
  MarketData.attachTo(document)
  GlobalData.attachTo(document, {ranger: window.ranger})
  MemberData.attachTo(document, {ranger: window.ranger}) if gon.accounts
#  CandlestickUI.attachTo('#candlestick')
  SwitchUI.attachTo('#range_switch, #indicator_switch, #main_indicator_switch, #type_switch')
  WalletSectionUI.attachTo('div.wallet-section')
  $('.panel-body-content').niceScroll
    autohidemode: true
    cursorborder: "none"
  $('.market-list-selection').niceScroll
    autohidemode: false
    cursorborder: "none"
    cursorcolor:"#2b5988"
# Datatable JS
window.sellBuyTablePageSize = 10
window.tradeTablePageSize = 10
window.sellTablePageNumber = 0
window.buyTablePageNumber = 0
window.tradeTablePageNumber = 0
BookDataTables =
  sellTableDes: ->
    $('#sell-orders-table').dataTable().fnDestroy();
  buyTableDes: ->
    $('#buy-orders-table').dataTable().fnDestroy();
  tradeTableDes: ->
    $('#all-trades-table').dataTable().fnDestroy();
  setPageNumber: (varName, value) ->
    eval("window.#{varName} = value")
  setupSellBinds: ->
    $('#sell-orders-table_paginate span a').click (e) ->
      BookDataTables.setPageNumber('sellTablePageNumber', parseInt($(e.target).text())-1)
    $('#sell-orders-table_paginate').find('a.paginate_button.previous').click (e) ->
      window.sellTablePageNumber = window.sellTablePageNumber-1
    $('#sell-orders-table_paginate').find('a.paginate_button.next').click (e) ->
      window.sellTablePageNumber = window.sellTablePageNumber+1
  setupBuyBinds: ->
    $('#buy-orders-table_paginate span a').click (e) ->
      BookDataTables.setPageNumber('buyTablePageNumber', parseInt($(e.target).text())-1)
    $('#buy-orders-table_paginate').find('a.paginate_button.previous').click (e) ->
      window.buyTablePageNumber = window.buyTablePageNumber-1
    $('#buy-orders-table_paginate').find('a.paginate_button.next').click (e) ->
      window.buyTablePageNumber = window.buyTablePageNumber+1
  setupTradeBinds: ->
    $('#all-trades-table_paginate span a').click (e) ->
      BookDataTables.setPageNumber('tradeTablePageNumber', parseInt($(e.target).text())-1)
    $('#all-trades-table_paginate').find('a.paginate_button.previous').click (e) ->
      window.tradeTablePageNumber = window.tradeTablePageNumber-1
    $('#all-trades-table_paginate').find('a.paginate_button.next').click (e) ->
      window.tradeTablePageNumber = window.tradeTablePageNumber+1
  sellTable: ->
    $('#sell-orders-table').DataTable
      'lengthMenu': [
        10
        25
        50
        100
        200
      ]
      'ordering': false
      'displayStart': (window.sellTablePageNumber*window.sellBuyTablePageSize)
      'pageLength': window.sellBuyTablePageSize
    this.setupSellBinds()
  buyTable: ->
    $('#buy-orders-table').DataTable
      'lengthMenu': [
        10
        25
        50
        100
        200
      ]
      'ordering': false
      'displayStart': (window.buyTablePageNumber*window.sellBuyTablePageSize)
      'pageLength': window.sellBuyTablePageSize
    this.setupBuyBinds()
  tradeTable: ->
    $('#all-trades-table').DataTable
      'lengthMenu': [
        10
        25
        50
        100
        200
      ]
      'ordering': false
      'displayStart': (window.tradeTablePageNumber*window.tradeTablePageSize)
      'pageLength': window.tradeTablePageSize
    this.setupTradeBinds()
window.BookDataTables = BookDataTables
$(document).on 'change', 'select[name=buy-orders-table_length], select[name=sell-orders-table_length]', (e) ->
  window.sellBuyTablePageSize = parseInt(event.target.value)
  window.buyTablePageNumber = 0
  window.sellTablePageNumber = 0
  BookDataTables.buyTableDes()
  BookDataTables.sellTableDes()
  BookDataTables.buyTable()
  BookDataTables.sellTable()
$(document).on 'change', 'select[name=all-trades-table_length]', (e) ->
  window.tradeTablePageSize = parseInt(event.target.value)
  window.tradeTablePageNumber = 0
  BookDataTables.tradeTableDes()
  BookDataTables.tradeTable()
