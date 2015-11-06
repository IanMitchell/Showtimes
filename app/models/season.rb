class Season < ActiveRecord::Base
  has_many :shows

  enum name: {
    winter: 0,
    spring: 1,
    summer: 2,
    fall: 3
  }

  def full_name
    "#{self.name.capitalize} #{self.year}"
  end
end
