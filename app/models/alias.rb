# == Schema Information
#
# Table name: aliases
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :integer
#
# Indexes
#
#  index_aliases_on_name     (name)
#  index_aliases_on_show_id  (show_id)
#

class Alias < ApplicationRecord
  belongs_to :show

  validates :name, presence: true,
                   uniqueness: true

  validates :show, presence: true
end
