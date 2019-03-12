# == Schema Information
#
# Table name: staff
#
#  id          :integer          not null, primary key
#  finished    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  member_id   :bigint(8)
#  position_id :integer
#  release_id  :integer
#
# Indexes
#
#  index_staff_on_member_id    (member_id)
#  index_staff_on_position_id  (position_id)
#  index_staff_on_release_id   (release_id)
#

class Staff < ApplicationRecord
  belongs_to :member
  belongs_to :position
  belongs_to :release, touch: true

  default_scope { order(position_id: :asc) }

  scope :pending, -> { where(finished: false) }
  scope :finished, -> { where(finished: true) }

  validates :position, presence: true

  validates :release, presence: true
end
