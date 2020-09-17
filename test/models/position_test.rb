# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  acronym    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_positions_on_acronym  (acronym)
#  index_positions_on_name     (name)
#

require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
