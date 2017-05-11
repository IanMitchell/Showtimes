class Position < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: true
                   
  validates :acronym, presence: true,
                      uniqueness: true

  def self.find_by_name_or_acronym(name)
    self.where('lower(name) = ? OR lower(acronym) = ?',
               name.downcase, name.downcase).first
  end
end
