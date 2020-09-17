# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fansub_id  :bigint           not null
#
# Indexes
#
#  index_terms_on_fansub_id  (fansub_id)
#  index_terms_on_name       (name)
#
# Foreign Keys
#
#  fk_rails_...  (fansub_id => fansubs.id)
#

class Term < ApplicationRecord
  belongs_to :fansub

  validates :name, presence: true,
                   uniqueness: true
end
