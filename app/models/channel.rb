# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  discord    :string
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Channel < ApplicationRecord
  belongs_to :group

  validates :name, presence: true,
                   uniqueness: true

  validates :group, presence: true
end
