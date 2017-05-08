class Episode < ApplicationRecord
  belongs_to :show
  belongs_to :volume
  belongs_to :season
  has_many :releases, as: :source, dependent: :destroy
end
