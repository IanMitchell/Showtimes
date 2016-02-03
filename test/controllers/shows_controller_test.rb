require 'test_helper'

class ShowsControllerTest < ActionController::TestCase
  test "should get all shows" do
    get :index, { format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['shows']
    assert body['shows'][0]['air_date']
    assert body['shows'][0]['alias']
  end

  test 'should get show by alias' do
    get :show, { id: 'aoty', format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['alias']
    assert body['air_date']
  end

  test 'should get show by name' do
    get :show, { id: "Desch's Slice of Life", format: :json }
    assert_response :success

    body = JSON.parse(response.body)
    assert body['alias']
    assert body['air_date']
  end
end
