# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  acronym    :string
#  name       :string
#  slug       :string
#  webhook    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_slug  (slug) UNIQUE
#

require "#{Rails.root}/lib/errors/show_not_found_error"
require "#{Rails.root}/lib/errors/fansub_not_found_error"
require "#{Rails.root}/lib/errors/group_not_found_error"

class Group < ApplicationRecord
  include FriendlyId

  has_many :members, through: :group_members
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
          .order("episodes.air_date DESC")
  end

  def find_fansub_for_show_fuzzy(name)
    begin
      show = self.shows.fuzzy_find(name)
    rescue Errors::ShowNotFoundError
      raise Errors::FansubNotFoundError
    end

    self.fansubs.where(show: show).first
  end

  def self.find_by_discord(discord)
    group = Channel.find_by(discord: discord)&.group
    raise Errors::GroupNotFoundError if group.nil?
    return group
  end
end
