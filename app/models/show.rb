class Show < ActiveRecord::Base
  belongs_to :season
  has_many :fansubs
  has_many :aliases
  has_many :episodes
  has_many :volumes

  def next_episode
    self.episodes.where('air_date >= :current_date', current_date: DateTime.now)
                 .order(number: :asc)
                 .limit(1)
                 .first
  end
end
