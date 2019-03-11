# == Schema Information
#
# Table name: staff
#
#  id          :integer          not null, primary key
#  position_id :integer
#  release_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  finished    :boolean          default(FALSE)
#  member_id   :bigint(8)
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
