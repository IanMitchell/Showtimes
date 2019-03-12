# == Schema Information
#
# Table name: fansubs
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :integer
#
# Indexes
#
#  index_fansubs_on_show_id  (show_id)
#

require "#{Rails.root}/lib/errors/fansub_finished_error"

class Fansub < ApplicationRecord
  has_many :group_fansubs, inverse_of: :fansub
  has_many :groups, through: :group_fansubs
  has_many :releases, inverse_of: :fansub
  belongs_to :show

  validates :show, presence: true

  validates :status, presence: true

  def current_release
    release = self.releases.pending.sort_by { |release| release.episode.number }.first
    raise Errors::FansubFinishedError, "The fansub for #{self.show.name} is complete!" if release.nil?
    return release
  end

  # Active Admin
  def display_name
    "#{self.groups.map(&:acronym).join('/')} #{self.show.name}"
  end
end
