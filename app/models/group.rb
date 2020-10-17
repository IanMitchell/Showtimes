# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  acronym    :string           not null
#  name       :string           not null
#  slug       :string
#  webhook    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_slug  (slug) UNIQUE
#

class Group < ApplicationRecord
  include FriendlyId

  before_destroy :cleanup_fansubs, prepend: true

  has_and_belongs_to_many :administrators
  has_many :members, inverse_of: :group, dependent: :destroy
  has_many :group_fansubs, inverse_of: :group, dependent: :destroy
  has_many :fansubs, through: :group_fansubs
  has_many :channels, inverse_of: :group, dependent: :destroy

  friendly_id :name, use: :slugged

  validates :name, presence: true,
                   uniqueness: true

  validates :acronym, presence: true,
                      uniqueness: true

  def find_fansub_by_name_fuzzy_search(name)
    fansubs = self.fansubs.visible.fuzzy_search(name)

    case fansubs.length
    when 0
      raise FansubNotFoundError
    when 1
      return fansubs.first
    else
      airing = fansubs.airing
      return airing.first if airing.length == 1

      incomplete = fansubs.active
      return incomplete.first if incomplete.length == 1

      names = fansubs.map { |fansub| fansub.name }.to_sentence
      raise MultipleMatchingFansubsError, "Multiple Matches: #{names}"
    end
  end

  def self.find_by_discord(discord)
    group = Group.joins(:channels).where(channels: { discord: discord}).first
    raise GroupNotFoundError if group.nil?
    return group
  end

  private
    def cleanup_fansubs
      self.fansubs.each do |fansub|
        fansub.delete unless fansub.joint?
      end
    end
end
