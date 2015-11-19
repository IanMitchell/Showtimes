class Group < ActiveRecord::Base
  include FriendlyId

  has_many :members
  has_many :users, through: :members
  has_many :fansubs

  friendly_id :name, use: :slugged

  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 1, maximum: 60 }

  validates :irc, presence: true,
                  uniqueness: true,
                  length: { minimum: 1, maximum: 30 }

  validates :acronym, presence: true,
                      uniqueness: true,
                      length: { minimum: 1, maximum: 30 }
end
