require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  test 'should require authentication' do
    put :update, {
      username: 'Desch',
      auth: 'wrongpassword',
      irc: '#gjm',
      name: 'aoty',
      format: :json
    }
    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unauthorized'), 'Incorrect error message'
  end

  test 'should fail with incorrect channel' do
    put :update, {
      username: 'Desch',
      auth: 'secretpassword',
      irc: '#gjm',
      name: 'aoty',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('irc'), 'Incorrect error message'
  end

  test 'should fail with non-staff channel' do
    put :update, {
      username: 'Desch',
      auth: 'secretpassword',
      irc: '#cartel',
      name: 'aoty',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('irc'), 'Incorrect error message'
  end

  test 'should fail with incorrect show' do
    put :update, {
      username: 'Desch',
      auth: 'secretpassword',
      irc: '#cartel-staff',
      name: 'aoty2',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('show'), 'Incorrect error message'
  end

  test 'should fail with incorrect fansub' do
  end

  test 'should fail with finished show' do
  end

  test 'should require all positions to be complete' do
  end

  test 'should succeed for correct show' do
  end
end
