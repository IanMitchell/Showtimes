require 'test_helper'

class StaffControllerTest < ActionController::TestCase
  test 'should restrict command to authorized requests' do
    put :update, {
      auth: 'lolno',
      irc: '#cartel',
      username: 'Desch',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unauthorized'), 'Incorrect error message'
  end

  test 'should not allow non-staff channels' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel',
      username: 'Desch',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('channel'), 'Incorrect error message'
  end

  test 'should not allow non-staff nicks' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'Belfiore',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('nick'), 'Incorrect error message'
  end

  test 'should not allow non-fansubbed shows' do
  end

  test 'should not allow non-staff to update show' do
  end

  test 'should not allow invalid positions' do
  end

  test 'should not require position when user has one position' do
  end

  test 'should require position when user has multiple positions' do
  end

  test 'should not allow incorrect staff position' do
  end

  test 'should allow founders to update any position for any show' do
  end

  test 'should correctly update show' do
  end
end
