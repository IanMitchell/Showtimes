# == Schema Information
#
# Table name: fansubs
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :integer
#
# Indexes
#
#  index_fansubs_on_show_id  (show_id)
#

require 'test_helper'

class FansubTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
