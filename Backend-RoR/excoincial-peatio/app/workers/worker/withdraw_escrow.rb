# encoding: UTF-8
# frozen_string_literal: true

module Worker
  class WithdrawEscrow
    def process(payload)
      payload.symbolize_keys!

      Rails.logger.warn { ">>>>> Received request for processing withdraw ##{payload[:id]}." }

      withdraw = Withdraw.find_by_id(payload[:id])

      unless withdraw
        Rails.logger.warn { "The withdraw with such ID doesn't exist in database." }
        return
      end

      unless withdraw.escrow?
        Rails.logger.warn { "The withdraw with such ID is not listed as an escrow." }
        return
      end

      withdraw.with_lock do
        unless withdraw.processing?
          Rails.logger.warn { "The withdraw is now being processed by different worker or has been already processed. Skipping..." }
          return
        end

        if withdraw.rid.blank?
          Rails.logger.warn { "The destination address doesn't exist. Skipping..." }
          withdraw.fail!
          return
        end

        Rails.logger.warn { "Information: sending #{withdraw.amount.to_s("F")} " \
                            "(exchange fee is #{withdraw.fee.to_s("F")}) " \
                            "#{withdraw.currency.code.upcase} to #{withdraw.rid}." }

        receiver_account ||= Member.find_by(code: withdraw.rid)
        receiver_account ||= Member.find_by(email: withdraw.rid)
        receiver_account ||= Member.find_by(sn: withdraw.rid)
        unless receiver_account.present?
          Rails.logger.warn { "Account with given destination address doesn\'t exist: #{params[:rid]}. Skipping..." }
          withdraw.fail!
          return
        end

        sender_account = withdraw.account
        sender_member = sender_account.member

        currency = withdraw.currency
#       balance = wallet_service.load_balance(wallet.address, currency)

#       if balance < withdraw.sum
#         Rails.logger.warn { "The withdraw skipped because wallet balance is not sufficient (wallet balance is #{balance.to_s("F")})." }
#         return
#       end

        # pa = withdraw.account.payment_address

#       Rails.logger.warn { "Sending request to Wallet Service." }

        txid = withdraw.tid

        Rails.logger.warn { "The currency API accepted withdraw and assigned transaction ID: #{txid}." }

        Rails.logger.warn { "Updating withdraw state in database." }
        data = {
          member: receiver_account,
          currency: currency,
          amount: withdraw.amount,
          tid: txid,
          txid: txid,
          fee: 0,
          address: receiver_account.code
        }
        Rails.logger.warn { "Creating a deposit." }
        deposit = ::Deposits::Fiat.new(data)
        if deposit.save
          deposit.with_lock do
            Rails.logger.warn { "Creating a deposit successful." }
            deposit.charge!
            Rails.logger.warn { "Charging a deposit successful." }
          end
          withdraw.dispatch
          withdraw.save!

          Rails.logger.warn { "OK." }
        else
          Rails.logger.warn { "Creating a deposit or dispatching a withdrawal failed." }
          raise Error, "Deposit errors #{deposit.errors.full_messages}\nWithdraw errors #{withdraw.errors.full_messages}"
        end

      rescue Exception => e
        begin
          Rails.logger.error { "Failed to process withdraw. See exception details below." }
          report_exception(e)
          Rails.logger.warn { "Setting withdraw state to failed." }
        ensure
          withdraw.fail!
          Rails.logger.warn { "OK." }
        end
      end
    end
  end
end
