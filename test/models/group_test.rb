# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  acronym    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  webhook    :string
#

require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
