# encoding: UTF-8
# frozen_string_literal: true

module MailerHelper

  private

    def set_unsubscribe_header
      headers["List-Unsubscribe-Post"] = "List-Unsubscribe=One-Click"
      Rails.logger.debug { "headers[\"List-Unsubscribe\"]  = \"<#{@unsubscribe}>\" " }
      headers["List-Unsubscribe"]  = "<#{@unsubscribe}>"
      headers['Precedence'] = "bulk" if validate_bulk_demanders headers[:to].to_s
    end

    def validate_bulk_demanders(host)
      bulk_demanders = %w|gmail.com papevis.com mail-tester.com|.map {|w| /@#{w}/i }
      bulk_demanders.map{|bd| bd =~ host}.any?
    end
end
