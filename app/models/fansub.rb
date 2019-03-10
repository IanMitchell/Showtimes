class Fansub < ApplicationRecord
  has_many :group_fansubs, inverse_of: :fansub
  has_many :groups, through: :group_fansubs
  has_many :releases, inverse_of: :fansub
  belongs_to :show

  validates :show, presence: true

  validates :status, presence: true

  def current_release
    release = self.releases.pending.sort_by { |release| release.episode.number }.first
    raise Showtimes::FansubFinishedError if release.nil?
    return release
  end

  # Active Admin
  def display_name
    "#{self.groups.map(&:acronym).join('/')} #{self.show.name}"
  end
end
