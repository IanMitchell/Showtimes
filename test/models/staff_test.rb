# == Schema Information
#
# Table name: staff
#
#  id          :integer          not null, primary key
#  finished    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  member_id   :bigint
#  position_id :integer
#  release_id  :integer
#
# Indexes
#
#  index_staff_on_finished     (finished)
#  index_staff_on_member_id    (member_id)
#  index_staff_on_position_id  (position_id)
#  index_staff_on_release_id   (release_id)
#

require 'test_helper'

class StaffTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
