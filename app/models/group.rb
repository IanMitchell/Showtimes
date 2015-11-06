class Group < ActiveRecord::Base
  include FriendlyId

  has_many :members
  has_many :users, through: :members
  has_many :fansubs

  friendly_id :name, use: :slugged
end
