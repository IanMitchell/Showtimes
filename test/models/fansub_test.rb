# == Schema Information
#
# Table name: fansubs
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  visible    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_fansubs_on_name  (name)
#

require 'test_helper'

class FansubTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
