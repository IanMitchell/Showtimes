class Station < ApplicationRecord
  has_many :releases, inverse_of: :station

  validates :name, presence: true,
                   uniqueness: true
end
