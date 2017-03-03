class Show < ActiveRecord::Base
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
    show = Alias.where('lower(name) = ?', str.downcase).first&.show
    return [show] unless show.nil?

    shows = where('lower(name) = ?', str.downcase)
    return shows unless shows.empty?

    where('lower(name) LIKE ?', "%#{sanitize_sql_like(str.downcase)}%")
  end

  def self.currently_airing(group)
    joins(:fansubs)
      .joins(:episodes)
      .where(fansubs: {
        group: group,
        status: Fansub.statuses[:active]
      },
      episodes: {
        season: Season.current
      })
      .distinct
  end
end
