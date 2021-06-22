class LoginHistory < ApplicationRecord
	belongs_to :account
end

# == Schema Information
# Schema version: 20190626065821
#
# Table name: login_histories
#
#  id         :bigint(8)        not null, primary key
#  apparaat   :string(255)
#  location   :string(255)
#  ip_address :string(255)
#  account_id :integer
#  verified   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
