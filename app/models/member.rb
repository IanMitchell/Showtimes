# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  discord    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_members_on_discord  (discord)
#

class Member < ApplicationRecord
  has_many :groups, through: :group_member

  enum role: {
    member: 0,
    admin: 1,
    founder: 2
  }
end
