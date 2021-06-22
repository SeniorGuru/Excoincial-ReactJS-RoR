# encoding: UTF-8
# frozen_string_literal: true

require File.join(ENV.fetch('RAILS_ROOT'), 'config', 'environment')

$running = true
Signal.trap("TERM") do
  $running = false
end

while($running) do
  Deposit.escrow.submitted.each do |deposit|
    begin
      Rails.logger.debug { "auditing deposit #{deposit.inspect}\nescrow? #{deposit.currency.escrow?}" }
      deposit.accept!
    rescue
      Rails.logger.error { "Error on deposit accept: #{$!}" }
      Rails.logger.debug { $!.backtrace.join("\n") }
    end
  end

  Deposit.escrow.accepted.each do |deposit|
    begin
      Rails.logger.debug { "auditing deposit #{deposit.inspect}\nescrow? #{deposit.currency.escrow?}" }
      withdraw = Withdraw.escrow.find_by( tid: deposit.tid )
      if withdraw.aasm_state == "confirming"
        withdraw.with_lock do
          withdraw.update txid: deposit.tid
          withdraw.success!
        end
      end
    rescue
      Rails.logger.error { "Error on deposit accept: #{$!}" }
      Rails.logger.debug { $!.backtrace.join("\n") }
    end
  end
  sleep 5
end
