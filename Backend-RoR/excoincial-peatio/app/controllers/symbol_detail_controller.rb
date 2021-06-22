class SymbolDetailController < ApplicationController
  layout 'history'
  def show
    currency = params[:currency]
    @currency = Currency.find(currency)
  end
end
