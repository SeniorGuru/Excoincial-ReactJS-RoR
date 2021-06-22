# encoding: UTF-8
# frozen_string_literal: true

module Private::HistoryHelper
  def trade_side(trade)
    trade.ask_member_id == current_user.id ? 'sell' : 'buy'
  end

  def transaction_type(t)
    t( ( t.currency.escrow? ? ".escrow" : "" ) +
       ".#{t.class.superclass.name}"
    ).split.map(&:capitalize).join(' ')
  end

  def display_currency(t)
    return t.currency.code.upcase unless t.currency.escrow?
    return ( "afcash" +
      display_escrow_agent( t.currency,' (#{agent} escrow)' ).to_s
    ).upcase
  end

  def display_escrow_agent(c,str="")
    return unless c.escrow? and str.present?
    begin
      agent = { vendescrow:"vendasity",
                foodescrow:"foodmoni"
      }.fetch(c.code.to_sym)
    rescue => e
      report_exception e
    end
    str = str.split(/\#\{[^\#\{\}]*\}/)
    return unless str.count > 1 and agent.present?
    return str.join(agent)
  end

  def transaction_txid_link(t)
    return t.txid if t.txid.blank? || !t.currency.coin?
    link_to t.txid, t.transaction_url
  end
end
