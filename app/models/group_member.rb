# == Schema Information
#
# Table name: group_members
#
#  id        :bigint(8)        not null, primary key
#  admin     :boolean          default(FALSE)
#  group_id  :bigint(8)
#  member_id :bigint(8)
#
# Indexes
#
#  index_group_members_on_group_id   (group_id)
#  index_group_members_on_member_id  (member_id)
#

class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :member
end
