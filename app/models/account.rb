class Account < ApplicationRecord
  belongs_to :user

  validates :user, presence: true

  validates :name, presence: true,
                   uniqueness: true

  validates :platform, presence: true

  enum platform: {
    irc: 0,
    discord: 1,
  }

  def self.from_platform(name)
    case name
    when 'irc'
      return 0
    when 'discord'
      return 1
    else
      return 0
    end
  end
end
