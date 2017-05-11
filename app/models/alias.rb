class Alias < ApplicationRecord
  belongs_to :show

  validates :name, presence: true,
                   uniqueness: true

  validates :show, presence: true
end
