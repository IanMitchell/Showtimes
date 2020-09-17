# == Schema Information
#
# Table name: releases
#
#  id         :integer          not null, primary key
#  air_date   :datetime         not null
#  number     :integer          not null
#  released   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fansub_id  :integer          not null
#
# Indexes
#
#  index_releases_on_fansub_id  (fansub_id)
#  index_releases_on_released   (released)
#

class Release < ApplicationRecord
  before_create :set_timezone
  after_create :extend_fansubs
  before_update :set_timezone
  
  belongs_to :episode
  belongs_to :fansub
  has_many :staff, dependent: :destroy, inverse_of: :release

  scope :pending, -> { where(released: false) }
  scope :released, -> { where(released: true) }

  validates :episode, presence: true

  validates :fansub, presence: true
  
  validates :air_date, presence: true
  
  validates :number, presence: true,
                     numericality: true,
                     uniqueness: { scope: :fansub, message: "fansub episodes should be unique" }

  # Active Admin
  def display_name
    "#{self.fansub.display_name} ##{self.episode.number}"
  end
  
  def season
    "#{Release.month_to_season(self.air_date.month)} #{self.air_date.year}"
  end
  
  def aired?
    self.air_date <= DateTime.now
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
      self.fansubs.each do |fansub|
        last_release = fansub.releases.last

        release = Release.create(fansub: fansub, episode: self)

        last_release.staff.each do |staff|
          Staff.create(member: staff.member, position: staff.position, release: release)
        end
      end
    end
end
