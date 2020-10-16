# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  admin      :boolean          default(FALSE)
#  discord    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint
#
# Indexes
#
#  index_members_on_discord   (discord)
#  index_members_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#

class Member < ApplicationRecord
  has_many :staff
  belongs_to :group

  validates :discord, presence: true,
                      uniqueness: { scope: :group, message: "Member Discord IDs should be unique" }

  validates :name, presence: true,
                   uniqueness: { scope: :group, message: "Member names should be unique" }

  def display_name
    "[#{self.group.acronym}] #{self.name}"
  end
end
