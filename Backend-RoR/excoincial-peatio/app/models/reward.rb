class Reward < ActiveRecord::Base
  scope :ordered, -> { order(id: :asc) }
  scope :with_member, -> (member_id) { where('member_id = ?', member_id) }
end

# == Schema Information
# Schema version: 20190328202357
#
# Table name: rewards
#
#  id            :integer          not null, primary key
#  ref_type      :string(255)
#  amount        :decimal(32, 16)  default(0.0), not null
#  order_id      :integer          not null
#  member_id     :integer          not null
#  ref_member_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_rewards_on_member_id      (member_id)
#  index_rewards_on_ref_member_id  (ref_member_id)
#
