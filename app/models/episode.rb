# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  air_date   :datetime
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :integer
#
# Indexes
#
#  index_episodes_on_show_id  (show_id)
#

class Episode < ApplicationRecord
  before_create :set_timezone
  after_create :extend_fansubs
  before_update :set_timezone

  belongs_to :show
  has_many :releases, dependent: :destroy, inverse_of: :episode

  validates :show, presence: true

  validates :number, presence: true,
                     numericality: true,
                     uniqueness: { scope: :show, message: "show episodes should be unique" }

  validates :air_date, presence: true

  def season
    "#{Episode.month_to_season(self.air_date.month)} #{self.air_date.year}"
  end

  def to_s
    "#{self.show.name} Episode #{self.number}"
  end

  private
    def self.month_to_season(month)
      case month
      when 1..3
        "Winter"
      when 4..6
        "Spring"
      when 7..9
        "Summer"
      when 10..12
        "Fall"
      end
    end

    def set_timezone
      unless self.air_date.zone.eql? 'JST'
        self.air_date = self.air_date.change(zone: 'Japan')
      end
    end

    def extend_fansubs
      self.show.fansubs.each do |fansub|
        last_release = fansub.releases.last

        release = Release.create(fansub: fansub, episode: self)

        last_release.staff.each do |staff|
          Staff.create(member: staff.member, position: staff.position, release: release)
        end
      end
    end
end
