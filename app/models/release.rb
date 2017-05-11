class Release < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :fansub
  belongs_to :station
  has_many :staff, dependent: :destroy, inverse_of: :release

  scope :pending, -> { where(released: false) }
  scope :released, -> { where(released: true) }

  validates :source, presence: true,
                     uniqueness: { scope: :source, message: "fansub releases should be unique" }

  validates :fansub, presence: true

  validates :category, presence: true

  validates :station, presence: true

  validates :released, presence: true

  enum category: {
    tv: 0,
    bluray: 1,
    batch: 2
  }

  # Active Admin
  def display_name
    "#{self.fansub.display_name} ##{self.source.number}"
  end
end
