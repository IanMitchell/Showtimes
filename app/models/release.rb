class Release < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :fansub
  belongs_to :channel

  enum status: {
    pending: 0,
    released: 1
  }

  enum category: {
    tv: 0,
    bluray: 1
  }
end
