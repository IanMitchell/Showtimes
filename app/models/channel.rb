class Channel < ApplicationRecord
  belongs_to :group

  validates :name, presence: true,
                   uniqueness: true

  validates :group, presence: true
end
