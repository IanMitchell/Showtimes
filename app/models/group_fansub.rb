# == Schema Information
#
# Table name: group_fansubs
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  fansub_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GroupFansub < ApplicationRecord
  belongs_to :group
  belongs_to :fansub
end
