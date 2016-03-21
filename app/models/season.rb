class Season < ActiveRecord::Base
  has_many :shows

  enum name: {
    winter: 0,
    spring: 1,
    summer: 2,
    fall: 3
  }

  def self.current
    self.find_by(name: Season.month_to_season(DateTime.now.month),
                   year: DateTime.now.year)
  end

  def full_name
    "#{self.name.capitalize} #{self.year}"
  end

  private

  def self.month_to_season(month)
    case month
    when 1..3
      self.names[:winter]
    when 4..6
      self.names[:spring]
    when 7..9
      self.names[:summer]
    when 10..12
      self.names[:fall]
    end
  end
end
