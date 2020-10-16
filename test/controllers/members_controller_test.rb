require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  test "should allow lookup of users" do
    get :show, params: {
      channel: 'cartel_discord',
      discord: 'desch',
      format: :json
    }

    assert_response 200
  end

  test "should not find users not part of a group" do
    get :show, params: {
      channel: 'priority_discord',
      discord: 'arx',
      format: :json
    }

    assert_response 404
  end

  test "should not allow duplicate members to be added" do
    put :create, params: {
      auth: ENV['AUTH'],
      channel: 'syndicate_discord',
      name: 'arx',
      discord: 'arx',
      format: :json
    }

    assert_response 400
  end

  test "should allow new members to be added" do
    put :create, params: {
      auth: ENV['AUTH'],
      channel: 'syndicate_discord',
      name: 'aquarius',
      discord: 'aquarius',
      format: :json
    }

    assert_response 200
  end
end
