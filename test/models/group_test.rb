# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  acronym    :string           not null
#  name       :string           not null
#  slug       :string
#  token      :string
#  webhook    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_slug   (slug) UNIQUE
#  index_groups_on_token  (token) UNIQUE
#

require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
