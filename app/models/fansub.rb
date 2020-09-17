# == Schema Information
#
# Table name: fansubs
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :integer
#
# Indexes
#
#  index_fansubs_on_show_id  (show_id)
#

require "#{Rails.root}/lib/errors/fansub_finished_error"

class Fansub < ApplicationRecord
  attr_accessor :default_staff
  attr_accessor :episode_count
  attr_accessor :air_date
  attr_writer :first_episode_number

  after_create :create_releases

  has_many :group_fansubs, inverse_of: :fansub, dependent: :destroy
  has_many :groups, through: :group_fansubs
  has_many :releases, inverse_of: :fansub, dependent: :destroy
  has_many :terms

  scope :airing, -> {
    joins(:releases)
      .merge(Release.where('air_date >= :current_date', current_date: DateTime.now))
      .distinct
  }
  scope :active, -> { joins(:releases).where('releases.released = false') }

  # Used when creating a fansub
  def first_episode_number
    @first_episode_number || 1
  end
  
  def next_episode
    self.releases.where('air_date >= :current_date', current_date: DateTime.now)
      .order(number: :asc)
      .first
  end
  
  def last_episode
    self.releases.order(air_date: :desc).first
  end
  
  def currently_airing?
    self.releases.where('air_date >= :current_date', current_date: DateTime.now).any?
  end
    
  def current_release
    self.releases.pending.order("releases.number ASC").first
  end

  def joint?
    self.groups.count > 1
  end

  def finished?
    self.current_release.nil?
  end
  
  def self.fuzzy_search(str)
    fansub = joins(:terms).where("lower(terms.name) = ?", str.downcase).first
    return [fansub] unless fansub.nil?

    fansubs = where('lower(fansubs.name) = ?', str.downcase)
    return fansubs unless fansubs.empty?

    where('lower(fansubs.name) LIKE ?', "%#{sanitize_sql_like(str.downcase)}%")
  end

  def self.fuzzy_find(str)
    fansubs = self.fuzzy_search(str)

    case fansubs.length
    when 0
      raise Errors::ShowNotFoundError
    when 1
      return fansubs.first
    else
      airing = fansubs.airing
      return airing.first if airing.length == 1

      names = fansubs.map { |fansub| fansub.name }.to_sentence
      raise Errors::MultipleMatchingShowsError, "Multiple Matches: #{names}"
    end
  end

  def notify_update(release, updated_staff_member)
    self.groups.each do |group|
      positions = {}

      # Determine current state
      release.staff.map do |staff|
        key = staff.position.acronym
        positions[key] = staff.finished? unless positions.include? key
        positions[key] = staff.finished? if positions[key] && !staff.finished
      end

      # Create the stylized acronym list
      positions_fields = positions.map do |key, value|
        str = value ? "~~#{key}~~" : "**#{key}**"

        if key == updated_staff_member.position.acronym
          "__#{str}__"
        else
          str
        end
      end

      if group.webhook?
        embed = Discord::Embed.new do
          title "#{self.name} ##{release.episode.number}"
          color updated_staff_member.finished ? 0x008000 : 0x800000
          add_field name: 'Status',
                    value: positions_fields.join(" ")
          footer text: DateTime.now.to_formatted_s(:long_ordinal)
        end

        Discord::Notifier.message embed, url: group.webhook
      end
    end
  end

  def notify_release(release)
    self.groups.each do |group|
      if group.webhook?
        embed = Discord::Embed.new do
          title self.name
          color 0x008000
          add_field name: 'Released!',
                    value: "#{self.name} ##{release.episode.number} was released!"
          footer text: DateTime.now.to_formatted_s(:long_ordinal)
        end

        Discord::Notifier.message embed, url: group.webhook
      end
    end
  end
end
