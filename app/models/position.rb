# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  acronym    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_positions_on_acronym  (acronym)
#  index_positions_on_name     (name)
#

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
