# encoding: UTF-8
# frozen_string_literal: true

module APIv2
  module Entities
    class Withdraw < Base
      expose :id
      expose :currency_id, as: :currency, documentation: { type: String, desc: 'The currency code.' }
      expose :tid, if: lambda {|w| w.currency_id == 'vendescrow' }, documentation: { type: String, desc: 'The shared transaction ID.' }
      expose(:uid, if: lambda {|w| w.currency_id == 'vendescrow' }, documentation: { type: String, desc: 'The shared user ID.' }) { |w| w.member.uid}
      expose(:type, documentation: { type: String, desc: 'The withdraw type (fiat or coin).' }) { |w| w.fiat? ? :fiat : :coin }
      expose :sum, as: :amount, documentation: { type: String, desc: 'The withdraw amount excluding fee.' }, format_with: :decimal
      expose :fee, documentation: { type: String, desc: 'The exchange fee.' }, format_with: :decimal
      expose :txid, as: :blockchain_txid, documentation: { type: String, desc: 'The transaction ID on the Blockchain (coin only).' }, if: -> (w, _) { w.coin? }
      expose :rid, documentation: { type: String, desc: 'The beneficiary ID or wallet address on the Blockchain.' }
      states = [
        '"prepared" .. inititial state, money are not locked.',
        '"submitted" .. withdraw has been allowed by outer service for further validation, money are locked.',
        '"canceled" .. withdraw has been canceled by outer service, money are unlocked.',
        '"accepted" .. system has validated withdraw and queued it for processing by officer, money are locked.',
        '"rejected" .. system has validated withdraw and found errors, money are unlocked.',
        '"suspected" .. system detected suspicious activity, money are unlocked.',
        '"processing" .. officer is processing withdraw as the current moment, money are locked.',
        '"succeed" .. officer has successfully processed withdraw, money are subtracted from the account.',
        '"failed" .. officer has encountered an unhandled error while processing withdraw, money are unlocked.'
      ]
      expose :aasm_state, as: :state, documentation: { type: String, desc: 'The withdraw state.<br>' + states.join('<br>') }
      expose :confirmations, if: ->(withdraw) { withdraw.coin? }
      expose :created_at, :updated_at, :completed_at, format_with: :iso8601
      expose :completed_at, as: :done_at, format_with: :iso8601, documentation: { type: String, desc: 'The datetime when withdraw was completed.' }
    end
  end
end
