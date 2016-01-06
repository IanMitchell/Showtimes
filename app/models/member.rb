class Member < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  enum role: {
    member: 0,
    admin: 1,
    founder: 2
  }
end
