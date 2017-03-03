class Release < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :fansub
  belongs_to :station
  has_many :staff, dependent: :destroy

  scope :pending, -> { where(released: false) }
  scope :released, -> { where(released: true) }

  enum category: {
    tv: 0,
    bluray: 1,
    batch: 2
  }
end
