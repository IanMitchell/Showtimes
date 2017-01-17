class Group < ActiveRecord::Base
  include FriendlyId

  has_many :members
  has_many :fansubs
  has_many :shows, through: :fansubs
  has_many :channels

  friendly_id :name, use: :slugged

  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 1, maximum: 60 }

  validates :acronym, presence: true,
                      uniqueness: true,
                      length: { minimum: 1, maximum: 30 }

  def fuzzy_search_subbed_shows(str)
    self.shows.fuzzy_search(str)
  end
end
