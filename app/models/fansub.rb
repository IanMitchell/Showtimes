class Fansub < ApplicationRecord
  has_many :group_fansubs, inverse_of: :fansub
  has_many :groups, through: :group_fansubs
  belongs_to :show
  has_many :releases, inverse_of: :fansub

  validates :show, presence: true

  validates :status, presence: true

  enum status: {
    active: 0,
    finished: 1,
    blurays: 2,
    dropped: 3
  }

  def current_release
    self.releases.pending.sort_by { |release| release.episode.number }.first
  end

  # Active Admin
  def display_name
    "#{self.groups.map(&:acronym).join('/')} #{self.show.name}"
  end
end
