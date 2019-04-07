# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :integer
#
# Indexes
#
#  index_terms_on_name     (name)
#  index_terms_on_show_id  (show_id)
#

class Term < ApplicationRecord
  belongs_to :show

  validates :name, presence: true,
                   uniqueness: true

  validates :show, presence: true
end
