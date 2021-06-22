# encoding: UTF-8
# frozen_string_literal: true

module BlockchainClient
  class Trunkcoin < Reecore

    def create_withdrawal!(issuer, recipient, amount, options = {})
      retries = 0
      begin
        if retries == 0
          Rails.logger.debug { "\n\ttry sendtoaddress with fee #{ options[:fee] }" }
          json_rpc(:settxfee, [options[:fee]]) if options.key?(:fee)
          amount_sub_fee = amount.to_f
        else
          fee = 0.0000193 / 1.9 * retries
          Rails.logger.debug { "\n\ttry sendtoaddress with fee #{ '%.10f' % fee }" }
          json_rpc(:settxfee, [('%.10f' % fee).to_f])
          amount_sub_fee = amount.to_f - fee.to_f
        end
        json_rpc(:sendtoaddress, [normalize_address(recipient.fetch(:address)), amount_sub_fee])
            .fetch('result')
            .yield_self(&method(:normalize_txid))
        #retries ||= 0
      rescue => e
        if (retries += 1) < 7
          report_exception(e)
          retry
        else
          raise e
        end
      end
    end
  end
end