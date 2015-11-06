class Episode < ActiveRecord::Base
  belongs_to :show
  belongs_to :volume
  has_many :releases, as: :source
end
