# == Schema Information
#
# Table name: releases
#
#  id         :integer          not null, primary key
#  released   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  episode_id :bigint(8)
#  fansub_id  :integer
#
# Indexes
#
#  index_releases_on_episode_id  (episode_id)
#  index_releases_on_fansub_id   (fansub_id)
#

class Release < ApplicationRecord
  belongs_to :episode
  belongs_to :fansub
  has_many :staff, dependent: :destroy, inverse_of: :release

  scope :pending, -> { where(released: false) }
  scope :released, -> { where(released: true) }

  validates :episode, presence: true

  validates :fansub, presence: true

  # Active Admin
  def display_name
    "#{self.fansub.display_name} ##{self.episode.number}"
  end
end
