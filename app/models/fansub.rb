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

  after_create :create_releases

  has_many :group_fansubs, inverse_of: :fansub, dependent: :destroy
  has_many :groups, through: :group_fansubs
  has_many :releases, inverse_of: :fansub, dependent: :destroy
  belongs_to :show

  scope :active, -> { joins(:releases).where('releases.released = false') }

  validates :show, presence: true

  def current_release
    self.releases.pending.joins(:episode).merge(Episode.order(number: :asc)).first
  end

  def joint?
    self.groups.count > 1
  end

  def finished?
    self.current_release.nil?
  end

  def notify_update(release, updated_staff_member)
    show = self.show

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
          title "#{show.name} ##{release.episode.number}"
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
    show = self.show

    self.groups.each do |group|
      if group.webhook?
        embed = Discord::Embed.new do
          title show.name
          color 0x008000
          add_field name: 'Released!',
                    value: "#{show.name} ##{release.episode.number} was released!"
          footer text: DateTime.now.to_formatted_s(:long_ordinal)
        end

        Discord::Notifier.message embed, url: group.webhook
      end
    end
  end

  private
    def create_releases
      staff_list = self.default_staff.reject(&:empty?)

      self.show.episodes.each do |episode|
        release = Release.create(fansub: self, episode: episode)
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
