# == Schema Information
#
# Table name: staff
#
#  id          :integer          not null, primary key
#  position_id :integer
#  release_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  finished    :boolean          default(FALSE)
#  member_id   :bigint(8)
#

require 'test_helper'

class StaffTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
