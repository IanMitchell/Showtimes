class Staff < ActiveRecord::Base
  belongs_to :user
  belongs_to :position
  belongs_to :release, touch: true

  default_scope { order(position_id: :asc) }

  scope :pending, -> { where(finished: false) }
  scope :finished, -> { where(finished: true) }
end
