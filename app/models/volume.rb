class Volume < ActiveRecord::Base
  belongs_to :show
  has_many :episodes
  has_many :releases, as: :source
end
