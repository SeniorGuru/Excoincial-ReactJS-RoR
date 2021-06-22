# encoding: UTF-8
# frozen_string_literal: true

module BlockchainClient
  class Reecore < Dash
    def get_raw_transaction(txid)
      tx_hex = json_rpc(:getrawtransaction, [txid,1]).fetch('result')
      tx_hex
    end

    def list_received_by_address(address)
      json_rpc(:listreceivedbyaddress).fetch('result').select{|a|  a['address'] == address}&.last&.fetch('txids')
    end

    def list_received_by_address(address)
      json_rpc(:listreceivedbyaddress).fetch('result').select{|a|  a['address'] == address}&.last&.fetch('txids')
    end

    def create_withdrawal!(issuer, recipient, amount, options = {})
      json_rpc(:settxfee, [options[:fee]]) if options.key?(:fee)
      json_rpc(:sendtoaddress, [normalize_address(recipient.fetch(:address)), amount.to_f])
          .fetch('result')
          .yield_self(&method(:normalize_txid))
    end
  end
end
