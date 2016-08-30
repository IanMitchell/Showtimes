require 'test_helper'

class BlameControllerTest < ActionController::TestCase
  test 'should succeed for subbed show' do
    get :show, { irc: '#cartel', show: 'aoty', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['name'], 'Name not in response'
    assert body['episode'], 'Ep# not in response'
    assert body['air_date'], 'Air Date not in response'
    assert body['status'], 'Staff not in response'
  end

  test 'should fail with incorrect channel' do
    get :show, { irc: '#gjm', show: 'aoty', format: :json }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('irc'), 'Incorrect error message'
  end

  test 'should fail with incorrect show' do
    get :show, { irc: '#cartel', show: 'aoty2', format: :json }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('show'), 'Incorrect error message'
  end

  test 'should fail with incorrect fansub' do
    get :show, { irc: '#cartel', show: 'fmp', format: :json }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('fansub'), 'Incorrect error message'
  end

  test 'should fail with completed fansub' do
    get :show, { irc: '#cartel', show: 'shigatsu', format: :json }
    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('complete'), 'Incorrect error message'
  end
end
