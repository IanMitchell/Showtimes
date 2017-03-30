class Fansub < ActiveRecord::Base
  has_many :groups, through: :group_fansubs
  has_many :group_fansubs
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
end
