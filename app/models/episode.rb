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
end
