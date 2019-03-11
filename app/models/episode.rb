# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  show_id    :integer
#  number     :integer
#  air_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  season     :integer
#  year       :integer
#

class Episode < ApplicationRecord
  belongs_to :show
  has_many :releases, dependent: :destroy, inverse_of: :episode

  validates :show, presence: true

  validates :number, presence: true,
                     numericality: true,
                     uniqueness: { scope: :show, message: "show episodes should be unique" }

  validates :air_date, presence: true

  enum season: {
    winter: 0,
    spring: 1,
    summer: 2,
    fall: 3
  }

  def self.current_season
    self.find_by(season: Episode.month_to_season(DateTime.now.month),
                 year: DateTime.now.year)
  end

  private

  def self.month_to_season(month)
    case month
    when 1..3
      self.names[:winter]
    when 4..6
      self.names[:spring]
    when 7..9
      self.names[:summer]
    when 10..12
      self.names[:fall]
    end
  end
end
