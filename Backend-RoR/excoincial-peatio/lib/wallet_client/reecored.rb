# encoding: UTF-8
# frozen_string_literal: true

module WalletClient
  class Reecored < Dashd
    def create_withdrawal!(issuer, recipient, amount, options = {})

      json_rpc(:settxfee, [options[:fee]]) if options.key?(:fee)
      json_rpc(:sendtoaddress, [normalize_address(recipient.fetch(:address)), amount.to_f])
          .fetch('result')
          .yield_self(&method(:normalize_txid))
    end
  end
end