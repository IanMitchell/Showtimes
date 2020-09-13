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
require "#{Rails.root}/lib/errors/member_not_found_error"
require "#{Rails.root}/lib/errors/fansub_not_found_error"
require "#{Rails.root}/lib/errors/group_not_found_error"

class Group < ApplicationRecord
  include FriendlyId

  before_destroy :cleanup_fansubs, prepend: true

  has_and_belongs_to_many :administrators
  has_many :group_members, inverse_of: :group, dependent: :destroy
  has_many :members, through: :group_members
  has_many :group_fansubs, inverse_of: :group, dependent: :destroy
  has_many :fansubs, through: :group_fansubs
  has_many :shows, through: :fansubs
  has_many :channels, inverse_of: :group, dependent: :destroy

  friendly_id :name, use: :slugged

  validates :name, presence: true,
                   uniqueness: true

  validates :acronym, presence: true,
                      uniqueness: true

  def find_member(discord)
    member = self.members.find_by(discord: discord)
    raise Errors::MemberNotFoundError if member.nil?
    return member
  end

  def fuzzy_search_subbed_shows(str)
    self.shows.fuzzy_search(str)
  end

  def airing_shows
    self.shows.airing
  end

  def active_fansubs
    self.fansubs.active.includes(show: :episodes).order("episodes.air_date DESC")
  end

  def find_fansub_for_show_fuzzy(name)
    begin
      show = self.shows.fuzzy_find(name)
    rescue Errors::ShowNotFoundError
      raise Errors::FansubNotFoundError
    end

    self.fansubs.where(show: show).first
  end

  def find_fansub_for_show_prioritized_fuzzy(name)
    shows = self.shows.fuzzy_search(name)

    case shows.length
    when 0
      raise Errors::FansubNotFoundError
    when 1
      return self.fansubs.where(show: shows.first).first
    else
      airing = shows.airing
      return self.fansubs.where(show: airing.first).first if airing.length == 1

      incomplete = self.active_fansubs.where(show: shows)
      return self.fansubs.where(show: incomplete.first.show).first if incomplete.length == 1

      names = shows.map { |show| show.name }.to_sentence
      raise Errors::MultipleMatchingShowsError, "Multiple Matches: #{names}"
    end
  end

  def self.find_by_discord(discord)
    group = Group.joins(:channels).where(channels: { discord: discord}).first
    raise Errors::GroupNotFoundError if group.nil?
    return group
  end

  private
    def cleanup_fansubs
      self.fansubs.each do |fansub|
        fansub.delete unless fansub.joint?
      end
    end
end
