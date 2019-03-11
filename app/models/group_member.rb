# == Schema Information
#
# Table name: group_members
#
#  id        :bigint(8)        not null, primary key
#  group_id  :bigint(8)
#  member_id :bigint(8)
#  admin     :boolean          default(FALSE)
#

class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :member
end
