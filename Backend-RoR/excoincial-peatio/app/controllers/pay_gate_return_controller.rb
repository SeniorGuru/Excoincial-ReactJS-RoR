class PayGateReturnController < ApplicationController
  def index
    transaction_reference = params[:TransactionReference]
    txid = params[:OrderID]
    deposit = Deposit.find_by_txid(txid)

    if !deposit.nil?
      deposit.update_attributes(comment: transaction_reference)
      deposit.collect!
    end

  	redirect_to account_history_path
  end
end