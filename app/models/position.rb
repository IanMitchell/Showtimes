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

require "#{Rails.root}/lib/errors/position_not_found_error"

class Position < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: true

  validates :acronym, presence: true,
                      uniqueness: true

  def self.find_by_name_or_acronym(name)
    position = self.where('lower(name) = ? OR lower(acronym) = ?',
      name.downcase,
      name.downcase)
      .first

      raise Errors::PositionNotFoundError if position.nil?
    return position
  end
end
