class Channel < ApplicationRecord
  belongs_to :group

  validates :name, presence: true,
                   uniqueness: true

  validates :group, presence: true

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
