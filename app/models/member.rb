# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#  discord    :string
#

class Member < ApplicationRecord
  has_many :groups, through: :group_member

  enum role: {
    member: 0,
    admin: 1,
    founder: 2
  }
end
