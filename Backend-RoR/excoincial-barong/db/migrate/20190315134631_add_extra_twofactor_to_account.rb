class AddExtraTwofactorToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :sms_otp, :boolean, default: false, after: :otp_enabled
    add_column :accounts, :email_otp, :boolean, default: false, after: :sms_otp
  end
end
