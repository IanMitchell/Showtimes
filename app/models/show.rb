class Show < ApplicationRecord
  has_many :fansubs, inverse_of: :show
  has_many :aliases, inverse_of: :show
  has_many :episodes, inverse_of: :show

  validates :name, presence: true,
                   uniqueness: true


  scope :airing, -> {
    joins(:episodes).where(episodes: { season: Season.current}).distinct
  }

  def next_episode
    self.episodes.where('air_date >= :current_date', current_date: DateTime.now)
                 .order(number: :asc)
                 .limit(1)
                 .first
  end

  def currently_airing?
    self.episodes.where(season: Season.current).any?
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
      raise Showtimes::ShowNotFoundError
    when 1
      return shows.first
    else
      names = shows.map { |show| show.name }.to_sentence
      raise Showtimes::MultipleMatchingShows "Multiple Matches: #{names}"
    end
  end
end
