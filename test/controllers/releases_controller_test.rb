require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  test 'should authenticate token' do
    put :update, params: {
      username: 'desch',
      token: 'incorrect_token',
      discord: 'cartel_discord',
      name: 'desch',
      format: :json
    }
    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('token'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should fail with incorrect discord' do
    put :update, params: {
      username: 'desch',
      token: 'syndicate_password',
      discord: '1234',
      name: 'desch',
      format: :json
    }
    assert_response 404

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unknown discord'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should fail with incorrect fansub' do
    put :update, params: {
      username: 'desch',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'fmp',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('associated fansub'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should fail with finished show' do
    put :update, params: {
      username: 'desch',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'kimi no uso',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('complete'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should require all positions to be complete' do
    put :update, params: {
      username: 'desch',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'desch',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('still pending'),
           "Incorrect error message: #{body['message']}"
    assert body['message'].downcase.include?('quality control, editor, timer'), 'Not all jobs listed'
    assert !body['message'].downcase.include?('translator'), 'Incorrect jobs listed'
  end

  test 'should succeed for correct show and ignore irrelevant show' do
    # Artificially set it as ready for release
    release = Fansub.where(name: "Desch's Slice of Life").first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: 'desch',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'desch',
      format: :json
    }
    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('#2 released'), 'Incorrect success message'
  end

  test 'should release show based on term' do
    # Artificially set it as ready for release
    release = Fansub.where(name: "Desch's Slice of Life").first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: 'desch',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'aoty',
      format: :json
    }
    assert_response 200
  end

  test 'should handle multiple show matches' do
    put :update, params: {
      username: 'desch',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'shigatsu',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('matches'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should support joint shows' do
    # Artificially set it as ready for release
    fansub = Fansub.where(name: 'Kono Subarashii Sekai ni Shukufuku wo!').first
    release = fansub.current_release

    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: 'desch',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'Subarashii',
      format: :json
    }

    assert_response 200

    # Reset (`release` is stale, need to query again)
    fansub.releases.first.update_attribute :released, false

    put :update, params: {
      username: 'arx',
      token: 'syndicate_token',
      discord: 'syndicate_discord',
      name: 'Subarashii',
      format: :json
    }

    assert_response 200
  end


  test 'should only allow Staff to release' do
    # Artificially set it as ready for release
    release = Fansub.where(name: "Desch's Slice of Life").first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: '132434896',
      token: 'cartel_token',
      discord: 'cartel_discord',
      name: 'aoty',
      format: :json
    }
    assert_response 404

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?("you aren't a group member!"),
           "Incorrect error message: #{body['message']}"
  end
end
