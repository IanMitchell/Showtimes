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
  after_create :create_releases

  has_many :group_fansubs, inverse_of: :fansub, dependent: :destroy
  has_many :groups, through: :group_fansubs
  has_many :releases, inverse_of: :fansub, dependent: :destroy
  belongs_to :show

  validates :show, presence: true

  def current_release
    release = self.releases.pending.sort_by { |release| release.episode.number }.first
    raise Errors::FansubFinishedError, "The fansub for #{self.show.name} is complete!" if release.nil?
    return release
  end

  def to_s
    "#{self.groups.map(&:acronym).join('/')} #{self.show.name}"
  end

  def joint?
    self.groups.count > 1
  end


  private
    def create_releases
      self.show.episodes.each do |episode|
        Release.create(fansub: self, episode: episode)
      end
    end
end
