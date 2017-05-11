class Group < ApplicationRecord
  include FriendlyId

  has_many :members, inverse_of: :group
  has_many :group_fansubs, inverse_of: :group
  has_many :fansubs, through: :group_fansubs
  has_many :shows, through: :fansubs, inverse_of: :group
  has_many :channels, inverse_of: :channels

  friendly_id :name, use: :slugged

  validates :name, presence: true,
                   uniqueness: true

  validates :acronym, presence: true,
                      uniqueness: true

  def fuzzy_search_subbed_shows(str)
    self.shows.fuzzy_search(str)
  end

  def airing_shows
    self.shows.airing
  end
end
