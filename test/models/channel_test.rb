# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  discord    :string
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
