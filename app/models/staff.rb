class Staff < ActiveRecord::Base
  belongs_to :user
  belongs_to :position
  belongs_to :release, touch: true

  default_scope { order(position_id: :asc) }

  enum status: {
    pending: 0,
    finished: 1
  }
end
