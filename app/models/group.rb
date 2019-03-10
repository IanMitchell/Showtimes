class Group < ApplicationRecord
  include FriendlyId

  has_and_belongs_to_many :members
  has_many :group_fansubs, inverse_of: :group
  has_many :fansubs, through: :group_fansubs
  has_many :shows, through: :fansubs
  has_many :channels, inverse_of: :group

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

  def active_fansubs
    Fansub.joins(:group_fansubs)
          .where(group_fansubs: { group: self })
          .active
          .includes(show: :episodes)
          .order("episodes.season_id DESC")
  end

  def find_fansub_for_show_fuzzy(name)
    show = Show.fuzzy_find(name)

    fansub = self.fansubs.where(show: show).first
    raise Showtimes::FansubNotFoundError if fansub.nil?

    return fansub
  end

  def self.find_by_discord(discord)
    group = Channel.find_by(discord: params[:channel])&.group
    raise Showtimes::GroupNotFoundError if group.nil?
    return group
  end
end
