class Channel < ActiveRecord::Base
  has_many :releases
end
