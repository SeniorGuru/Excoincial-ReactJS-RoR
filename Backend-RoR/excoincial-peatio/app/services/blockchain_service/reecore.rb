# encoding: UTF-8
# frozen_string_literal: true

module BlockchainService
  class Reecore < Dash
    def build_deposits(block_json, block_id)
      block_json
        .fetch('tx')
        .each_with_object([]) do |tx, deposits|

        # get raw transaction
        txn = client.get_raw_transaction(tx)
        payment_addresses_where(address: client.to_address(txn)) do |payment_address|
          # If payment address currency doesn't match with blockchain
          
          list_address_txs = client.list_received_by_address(payment_address.address)
          puts list_address_txs
          deposit_txs = client.build_transaction(txn, block_id, payment_address.address)

          deposit_txs.fetch(:entries).each do |entry|
            if entry[:amount] <= payment_address.currency.min_deposit_amount
              # Currently we just skip small deposits. Custom behavior will be implemented later.
              Rails.logger.info do  "Skipped deposit with txid: #{deposit_txs[:id]} with amount: #{entry[:amount]}"\
                                     " from #{entry[:address]} in block number #{deposit_txs[:block_number]}"
              end
              next
            end
            deposits << { txid:           deposit_txs[:id],
                          address:        entry[:address],
                          amount:         entry[:amount],
                          member:         payment_address.account.member,
                          currency:       payment_address.currency,
                          txout:          entry[:txout],
                          block_number:   deposit_txs[:block_number] }
          end
        end
      end
    end
  end
end
