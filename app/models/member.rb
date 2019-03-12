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
  has_many :group_members, inverse_of: :member
  has_many :groups, through: :group_members

  def admin?(group)
    self.group_members.where(group: group, admin: true).exists?
  end
end
