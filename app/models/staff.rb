class Staff < ApplicationRecord
  belongs_to :user
  belongs_to :position
  belongs_to :release, touch: true

  default_scope { order(position_id: :asc) }

  scope :pending, -> { where(finished: false) }
  scope :finished, -> { where(finished: true) }

  validates :user, presence: true,
                   uniqueness: {
                     scope: [:position, :release],
                     message: "user positions should be unique"
                   }

  validates :position, presence: true

  validates :release, presence: true
end
