require 'test_helper'

class ShowsControllerTest < ActionController::TestCase
  test "should get all shows" do
    get :index, params: { irc: '#cartel', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['shows']
    assert body['shows'][0]['air_date']
    assert body['shows'][0]['alias']
  end

  test 'should get show by alias' do
    get :show, params: { id: 'aoty', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['alias']
    assert body['air_date']
  end

  test 'should get show by name' do
    get :show, params: { id: "Desch's Slice of Life", format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['alias']
    assert body['air_date']
  end

  test 'should handle incorrect show' do
    get :show, params: { id: 'GJM', format: :json }
    assert_response :not_found

    body = JSON.parse(response.body)
    assert body['message']
  end
end
