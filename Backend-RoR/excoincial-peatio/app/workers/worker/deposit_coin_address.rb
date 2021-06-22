# encoding: UTF-8
# frozen_string_literal: true

module Worker
  class DepositCoinAddress
    def process(payload)
      payload.symbolize_keys!

      acc = Account.find_by_id(payload[:account_id])
      return unless acc
      return unless acc.currency.coin?

      wallet = Wallet.active.deposit.find_by(currency_id: acc.currency_id)
      return unless wallet

      wallet_service = WalletService[wallet]

      acc.payment_address.tap do |pa|
        pa.with_lock do
          next if pa.address.present?

          # If Erc20 tokens then share with eth address
          unless acc.currency.erc20_contract_address.blank?
            # If eth address not exists then create it before supplying address ID.
            if acc.member.payment_addresses.select(:address, :secret).where(:currency_id => :eth)&.last.nil?
              # Supply address ID in case of BitGo address generation if it exists.
              result = wallet_service.create_address \
                address_id: pa.details['bitgo_address_id'],
                label:      acc.member.uid
              puts acc.member.inspect
              pa_eth = acc.member.payment_addresses.find_by :currency_id => :eth
              acc_eth = acc.member.accounts.find_by :currency_id => :eth
              # Create eth account if not exists
              acc_eth.payment_addresses.create!(currency: Currency.find(:eth)) unless pa_eth.present?
              pa_eth = acc.member.payment_addresses.find_by :currency_id => :eth
              pa_eth.update \
                result.extract!(:address, :secret).merge!(details: pa_eth.details.merge(result)) unless result.nil?
            end
            result = acc.member.payment_addresses.select(:address, :secret).where(:currency_id => :eth)&.last&.as_json&.symbolize_keys&.except(:id)
          else
            # Supply address ID in case of BitGo address generation if it exists.
            result = wallet_service.create_address \
            address_id: pa.details['bitgo_address_id'],
            label:      acc.member.uid
          end

          # Save all the details including address ID from BitGo to use it later.
          pa.update! \
            result.extract!(:address, :secret).merge!(details: pa.details.merge(result)) unless
            result.nil?
        end

        # Enqueue address generation again if address is not provided.
        pa.enqueue_address_generation if pa.address.blank?

        trigger_pusher_event(acc, pa) unless pa.address.blank?
      end

    # Don't re-enqueue this job in case of error.
    # The system is designed in such way that when user will
    # request list of accounts system will ask to generate address again (if it is not generated of course).
    rescue => e
      report_exception(e)
    end

  private

    def trigger_pusher_event(acc, pa)
      Member.trigger_pusher_event acc.member_id, :deposit_address, type: :create, attributes: {
        currency: pa.currency.code,
        address:  pa.address
      }
    end
  end
end
