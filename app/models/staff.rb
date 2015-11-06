class Staff < ActiveRecord::Base
  belongs_to :user
  belongs_to :position
  belongs_to :release

  enum status: {
    pending: 0,
    finished: 1
  }
end
