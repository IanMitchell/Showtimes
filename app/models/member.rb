class Member < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  enum status: {
    active: 0,
    inactive: 1
  }

  enum role: {
    member: 0,
    admin: 1,
    founder: 2
  }
end
