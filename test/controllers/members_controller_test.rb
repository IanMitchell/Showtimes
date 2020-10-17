require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  test "should reject invalid tokens" do
    put :create, params: {
      token: 'invalid_token',
      discord: 'syndicate_discord',
      user_name: 'arx',
      user_id: 'arx',
      format: :json
    }

    assert_response 401
  end

  test "should allow lookup of users" do
    get :show, params: {
      discord: 'cartel_discord',
      user_id: 'desch',
      format: :json
    }

    assert_response 200
  end

  test "should not find users not part of a group" do
    get :show, params: {
      discord: 'priority_discord',
      user_id: 'arx',
      format: :json
    }

    assert_response 404
  end

  test "should update existing members" do
    group = Group.find_by(name: 'Syndicate')
    member =  Member.find_by(name: 'arx', discord: 'arx', group: group)

    assert_equal member.admin, false

    put :create, params: {
      token: 'syndicate_token',
      discord: 'syndicate_discord',
      user_name: 'arx',
      user_id: 'arx',
      admin: true,
      format: :json
    }

    member =  Member.find_by(name: 'arx', discord: 'arx', group: group)

    assert_response 200
    assert member.admin?
  end

  test "should allow new members to be added" do
    put :create, params: {
      token: 'syndicate_token',
      discord: 'syndicate_discord',
      user_name: 'aquarius',
      user_id: 'aquarius',
      format: :json
    }

    assert_response 200
  end
end
