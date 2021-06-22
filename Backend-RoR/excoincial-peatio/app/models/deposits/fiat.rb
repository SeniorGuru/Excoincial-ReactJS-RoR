# encoding: UTF-8
# frozen_string_literal: true

module Deposits
  class Fiat < Deposit
    has_one :blockchain, through: :currency

    validate { errors.add(:currency, :invalid) if currency && !currency.fiat? }

    def charge!
      with_lock { accept! }
    end

    def parse_tx
      return unless escrow?
      t = txid
      t ||= tid
      return unless t.present?
      Hash[ [:ots, :aid, :oid, :reason].zip t.unpack("a10a6a6a*") ] if
        tid.instance_of? String and
        tid.length >= ( 10 + 6 + 6 + 5 )
    end

    def escrow_agreement
      begin
        pt = parse_tx
        [
        class_eval(type).human_attribute_name( "escrow/agreements/according" ).capitalize,
        "******" + pt[:aid],
        class_eval(type).human_attribute_name( "escrow/agreements/dated" ).downcase,
        Time.at( pt[:ots].to_i ).strftime( "%d/%m/%Y" )
        ].join ' '
      rescue
        Rails.logger.debug { "details txid #{txid} tid #{tid}" }
        Rails.logger.error { "Return agreement details error: " }
        report_exception(e)
      end
    end

    def escrow_release_reason
      begin
        pt = parse_tx
        [
          class_eval(type).human_attribute_name( "escrow/reason" ).capitalize + ':',
          class_eval(type).human_attribute_name( "escrow/reasons/#{pt[:reason]}" ).downcase,
        ].join ' '
      rescue => e
        Rails.logger.debug { "details txid #{txid} tid #{tid}" }
        Rails.logger.error { "Return release escrow reason details error: " }
        report_exception(e)
      end
    end
  end
end

# == Schema Information
# Schema version: 20190912132009
#
# Table name: deposits
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  currency_id  :string(10)       not null
#  amount       :decimal(32, 16)  not null
#  fee          :decimal(32, 16)  not null
#  address      :string(95)
#  txid         :string(128)
#  txout        :integer
#  aasm_state   :string(30)       not null
#  block_number :integer
#  type         :string(30)       not null
#  tid          :string(64)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  completed_at :datetime
#  comment      :string(255)
#
# Indexes
#
#  index_deposits_on_aasm_state_and_member_id_and_currency_id  (aasm_state,member_id,currency_id)
#  index_deposits_on_currency_id                               (currency_id)
#  index_deposits_on_currency_id_and_txid_and_txout            (currency_id,txid,txout) UNIQUE
#  index_deposits_on_member_id_and_txid                        (member_id,txid)
#  index_deposits_on_tid                                       (tid)
#  index_deposits_on_type                                      (type)
#
