class Show < ActiveRecord::Base
  belongs_to :season
  has_many :fansubs
  has_many :aliases
  has_many :episodes
  has_many :volumes
end
