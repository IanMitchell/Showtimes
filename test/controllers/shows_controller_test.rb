require 'test_helper'

class ShowsControllerTest < ActionController::TestCase
  test "should get all shows" do
    get :index, params: { channel: 'cartel_discord', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['shows']
    assert body['shows'][0]['air_date']
    assert body['shows'][0]['term']
  end

  test 'should get show by term' do
    get :show, params: { id: 'aoty', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['term']
    assert body['air_date']
  end

  test 'should get show by name' do
    get :show, params: { id: "Desch's Slice of Life", format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['term']
    assert body['air_date']
  end

  test 'should handle incorrect show' do
    get :show, params: { id: 'GJM', format: :json }
    assert_response :not_found

    body = JSON.parse(response.body)
    assert body['message']
  end
end
