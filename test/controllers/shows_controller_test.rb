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
end
