class ApplicationMailer < ActionMailer::Base
  include MailerHelper

  helper :application

  default from: ENV.fetch('SENDER_NAME', 'barong').downcase + "-noreply" + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>'
  default 'Content-Transfer-Encoding' => "quoted-printable"
  layout 'mailer'

end
