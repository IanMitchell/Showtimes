class Episode < ApplicationRecord
  belongs_to :show
  belongs_to :volume
  belongs_to :season
  has_many :releases, as: :source, dependent: :destroy, inverse_of: :source

  validates :show, presence: true

  validates :season, presence: true

  validates :number, presence: true,
                     numericality: true,
                     uniqueness: { scope: :show, message: "show episodes should be unique" }

  validates :air_date, presence: true
end
