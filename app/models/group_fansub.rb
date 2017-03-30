class GroupFansub < ActiveRecord::Base
  belongs_to :group
  belongs_to :fansub
end
