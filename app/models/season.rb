class Season < ActiveRecord::Base
  has_many :shows

  enum name: {
    winter: 0,
    spring: 1,
    summer: 2,
    fall: 3
  }

  def self.current
    year = DateTime.now.year
    month = DateTime.now.month

    case month
    when 1..3
      puts "winter"
      name = Season.names[:winter]
    when 4..6
      puts "spring"
      name = Season.names[:spring]
    when 7..9
      puts "summer"
      name = Season.names[:summer]
    when 10..12
      puts "fall"
      name = Season.names[:fall]
    end
    puts name

    Season.find_by(name: name, year: year)
  end

  def full_name
    "#{self.name.capitalize} #{self.year}"
  end
end
