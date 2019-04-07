# == Schema Information
#
# Table name: group_fansubs
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fansub_id  :integer
#  group_id   :integer
#
# Indexes
#
#  index_group_fansubs_on_fansub_id  (fansub_id)
#  index_group_fansubs_on_group_id   (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (fansub_id => fansubs.id)
#  fk_rails_...  (group_id => groups.id)
#

class GroupFansub < ApplicationRecord
  belongs_to :group
  belongs_to :fansub

  validates :group, presence: true

  validates :fansub, presence: true

  def to_s
    self.group.name
  end
end
