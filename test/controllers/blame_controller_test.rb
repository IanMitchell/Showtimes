require 'test_helper'

class BlameControllerTest < ActionController::TestCase
  test 'should succeed for subbed show' do
    get :show, params: { channel: 'cartel_discord', show: 'aoty', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['name'], 'Name not in response'
    assert body['episode'], 'Ep# not in response'
    assert body['air_date'], 'Air Date not in response'
    assert body['status'], 'Staff not in response'
  end

  test 'should fail with unknown discord' do
    get :show, params: { channel: '3', show: 'aoty', format: :json }
    assert_response 404

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unknown discord'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should fail with incorrect fansub' do
    get :show, params: { channel: 'cartel_discord', show: 'shomin', format: :json }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('fansub'),
          "Incorrect error message: #{body['message']}"
  end

  test 'should fail with completed fansub' do
    get :show, params: { channel: 'cartel_discord', show: 'kimi', format: :json }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('complete'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should ignore multiple matches for irrelevant shows' do
    get :show, params: { channel: 'cartel_discord', show: 'desch', format: :json }
    assert_response 200
  end

  test 'should respond to term' do
    get :show, params: { channel: 'cartel_discord', show: 'aoty', format: :json }
    assert_response 200
  end

  test 'should handle multiple show matches' do
    get :show, params: { channel: 'cartel_discord', show: 'shigatsu', format: :json }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('match'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should support joint shows' do
    ['1', '2'].each do |channel|
      get :show, params: { channel: channel, show: 'Subarashii', format: :json }
      assert_response 200

      body = JSON.parse(response.body)
      assert body['name'], 'Name not in response'
    end
  end

  test 'should find show based on partial encoded name' do
    get :show, params: { channel: 'cartel_discord', show: 'Sekai%20Ni', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['name'], 'Name not in response'
  end

  test 'should prioritize incomplete fansubs' do
    get :show, params: { channel: 'priority_discord', show: 'kaguya', format: :json }
    assert_response 200

    body = JSON.parse(response.body)
    assert_equal body['name'], 'Kaguya S2', 'Priority not given to incomplete show'
  end
end
