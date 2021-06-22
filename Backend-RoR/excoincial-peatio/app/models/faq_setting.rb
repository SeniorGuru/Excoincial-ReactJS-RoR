class FaqSetting < ActiveRecord::Base
end

# == Schema Information
# Schema version: 20190213185615
#
# Table name: faq_settings
#
#  id         :integer          not null, primary key
#  question   :string(255)      not null
#  answer     :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
