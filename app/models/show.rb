class Show < ActiveRecord::Base
  belongs_to :season
  has_many :fansubs
  has_many :aliases
  has_many :episodes
  has_many :volumes


  def self.find_by_name_or_alias(name)
    show = self.where('lower(name) = ?', name.downcase).first
    show ||= Alias.where('lower(name) = ?', name.downcase).first&.show
  end

  def next_episode
    self.episodes.where('air_date >= :current_date', current_date: DateTime.now)
                 .order(number: :asc)
                 .limit(1)
                 .first
  end

  def self.fuzzy_search(str)
    # TODO: Check aliases
    # shows = Alias.where(name: str)
    # return shows unless shows.nil?

    shows = where('lower(name) = ?', str.downcase)
    return shows unless shows.empty?

    shows = where('lower(name) LIKE ?', "%#{sanitize_sql_like(str.downcase)}%")
  end
end
