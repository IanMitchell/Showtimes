class Fansub < ApplicationRecord
  has_many :group_fansubs
  has_many :groups, through: :group_fansubs
  belongs_to :show
  has_many :releases

  enum status: {
    active: 0,
    finished: 1,
    blurays: 2,
    dropped: 3
  }

  def current_release
    self.releases.pending.sort_by { |release| release.source.number }.first
  end

  # Active Admin
  def display_name
    "#{self.groups.map(&:acronym).join('/')} #{self.show.name}"
  end
end
