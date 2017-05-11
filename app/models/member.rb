class Member < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :group, presence: true

  validates :user, presence: true,
                   uniqueness: { scope: :group, message: "already in group" }

  validates :role, presence: true

  validates :title, presence: true

  enum role: {
    member: 0,
    admin: 1,
    founder: 2
  }
end
