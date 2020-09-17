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
  attr_accessor :episode_count
  attr_accessor :air_date
  attr_writer :first_episode_number

  after_create :create_episodes

  has_many :fansubs, inverse_of: :show, dependent: :destroy
  has_many :terms, inverse_of: :show, dependent: :destroy
  has_many :episodes, inverse_of: :show, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: true

  scope :airing, -> {
    joins(:episodes)
    .merge(Episode.where('air_date >= :current_date', current_date: DateTime.now))
    .distinct
  }

  attr_writer :politics

  # Used when creating a show
  def first_episode_number
    @first_episode_number || 1
  end

  def next_episode
    self.episodes.where('air_date >= :current_date', current_date: DateTime.now)
                 .order(number: :asc)
                 .first
  end

  def last_episode
    self.episodes.order(air_date: :desc).first
  end

  def currently_airing?
    self.episodes.where('air_date >= :current_date', current_date: DateTime.now).any?
  end

  def self.find_by_name_or_term(name)
    show = self.where('lower(shows.name) = ?', name.downcase).first
    show ||= Term.where('lower(shows.name) = ?', name.downcase).first&.show
  end

  def self.fuzzy_search(str)
    show = joins(:terms).where("lower(terms.name) = ?", str.downcase).first
    return [show] unless show.nil?

    shows = where('lower(shows.name) = ?', str.downcase)
    return shows unless shows.empty?

    where('lower(shows.name) LIKE ?', "%#{sanitize_sql_like(str.downcase)}%")
  end

  def self.fuzzy_find(str)
    shows = self.fuzzy_search(str)

    case shows.length
    when 0
      raise Errors::ShowNotFoundError
    when 1
      return shows.first
    else
      airing = shows.airing
      return airing.first if airing.length == 1

      names = shows.map { |show| show.name }.to_sentence
      raise Errors::MultipleMatchingShowsError, "Multiple Matches: #{names}"
    end
  end


  private
    def create_episodes
      self.episode_count.to_i.times do |num|
        Episode.create(
          show: self,
          number: self.first_episode_number.to_i + num,
          air_date: self.air_date.to_datetime + num.weeks
        )
      end
    end
end
