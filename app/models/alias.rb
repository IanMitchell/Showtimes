# == Schema Information
#
# Table name: aliases
#
#  id         :integer          not null, primary key
#  show_id    :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Alias < ApplicationRecord
  belongs_to :show

  validates :name, presence: true,
                   uniqueness: true

  validates :show, presence: true
end
