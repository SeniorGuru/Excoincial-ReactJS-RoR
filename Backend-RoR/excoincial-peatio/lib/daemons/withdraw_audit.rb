# encoding: UTF-8
# frozen_string_literal: true

require File.join(ENV.fetch('RAILS_ROOT'), 'config', 'environment')

$running = true
Signal.trap("TERM") do
  $running = false
end

while($running) do
  Withdraw.submitted.each do |withdraw|
    begin
      Rails.logger.debug { "auditing withdraw #{withdraw.inspect}\nescrow? #{withdraw.currency.escrow?}" }
      if withdraw.currency.escrow?
          withdraw.audit!
      end
    rescue
      Rails.logger.error { "Error on withdraw audit: #{$!}" }
      Rails.logger.debug { $!.backtrace.join("\n") }
    end
  end

  sleep 5
end
