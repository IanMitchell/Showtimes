# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string
#  tvdb_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_shows_on_name  (name)
#

require "#{Rails.root}/lib/errors/show_not_found_error"
require "#{Rails.root}/lib/errors/multiple_matching_shows_error"

class Show < ApplicationRecord
  has_many :fansubs, inverse_of: :show
  has_many :aliases, inverse_of: :show
  has_many :episodes, inverse_of: :show

  validates :name, presence: true,
                   uniqueness: true


  scope :airing, -> {
    joins(:episodes).where(episodes: { 'air_date > ?': DateTime.now }).distinct
  }

  def next_episode
    self.episodes.where('air_date >= :current_date', current_date: DateTime.now)
                 .order(number: :asc)
                 .limit(1)
                 .first
  end

  def currently_airing?
    self.episodes.where('air_date >= :current_date', current_date: DateTime.now).any?
  end

  def self.find_by_name_or_alias(name)
    show = self.where('lower(name) = ?', name.downcase).first
    show ||= Alias.where('lower(name) = ?', name.downcase).first&.show
  end

  def self.fuzzy_search(str)
    show = Alias.where('lower(name) = ?', str.downcase).first&.show
    return [show] unless show.nil?

    shows = where('lower(name) = ?', str.downcase)
    return shows unless shows.empty?

    where('lower(name) LIKE ?', "%#{sanitize_sql_like(str.downcase)}%")
  end

  def self.fuzzy_find(str)
    shows = self.fuzzy_search(str)

    case shows.length
    when 0
      raise Errors::ShowNotFoundError
    when 1
      return shows.first
    else
      names = shows.map { |show| show.name }.to_sentence
      raise Errors::MultipleMatchingShowsError, "Multiple Matches: #{names}"
    end
  end
end
