class Fansub < ActiveRecord::Base
  belongs_to :group
  belongs_to :show
  has_many :releases

  enum status: {
    active: 0,
    finished: 1,
    blurays: 2,
    dropped: 3
  }
end
