# == Schema Information
#
# Table name: fansubs
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  visible    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_fansubs_on_name     (name)
#  index_fansubs_on_visible  (visible)
#

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

  scope :visible, -> { where(visible: true) }

  scope :active, -> { includes(:releases).where(releases: { released: false }) }

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

  def airing?
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

  def notify_update(release, updated_staff_member)
    name = self.name
    self.groups.each do |group|
      # Determine current state
      positions_fields = release.staff.map do |staff|
        str = staff.finished? ? "~~#{key}~~" : "**#{key}**"

        if staff == updated_staff_member
          "__#{str}__"
        else
          str
        end
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
          title "#{name} ##{release.number}"
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
    name = self.name

    self.groups.each do |group|
      if group.webhook?
        embed = Discord::Embed.new do
          title name
          color 0x008000
          add_field name: 'Released!',
                    value: "#{name} ##{release.number} was released!"
          footer text: DateTime.now.to_formatted_s(:long_ordinal)
        end

        Discord::Notifier.message embed, url: group.webhook
      end
    end
  end

  private
    def create_releases
      staff_list = self.default_staff.reject(&:empty?)

      self.episode_count.to_i.times do |num|
        release = Release.create(
          fansub: self,
          number: self.first_episode_number.to_i + num,
          air_date: self.air_date.to_datetime + num.weeks
        )

        staff_list.each do |staff|
          arr = staff.scan(/\d+/).map(&:to_i)
          Staff.create(
            member: Member.find(arr[1]),
            position: Position.find(arr[0]),
            release: release
          )
        end
      end
    end
end
