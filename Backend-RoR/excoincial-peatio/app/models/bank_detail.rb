class BankDetail < ActiveRecord::Base
	belongs_to :member
end

# == Schema Information
# Schema version: 20190711112105
#
# Table name: bank_details
#
#  id               :integer          not null, primary key
#  member_id        :integer
#  bank_name        :string(255)
#  account_no       :string(255)
#  account_name     :string(255)
#  swift_code       :string(255)
#  bank_branch      :string(255)
#  bank_branch_code :string(255)
#  bank_address     :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  iban             :string(255)
#
