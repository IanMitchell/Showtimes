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

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
