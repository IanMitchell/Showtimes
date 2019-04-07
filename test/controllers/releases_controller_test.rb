require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  test 'should require authentication' do
    put :update, params: {
      username: '123',
      auth: 'wrongpassword',
      channel: '1',
      name: 'desch',
      format: :json
    }
    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unauthorized'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should fail with incorrect channel' do
    put :update, params: {
      username: '123',
      auth: ENV['AUTH'],
      channel: '1234',
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
      username: '123',
      auth: ENV['AUTH'],
      channel: '1',
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
      username: '123',
      auth: ENV['AUTH'],
      channel: '1',
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
      username: '123',
      auth: ENV['AUTH'],
      channel: '1',
      name: 'desch',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('still pending'),
           "Incorrect error message: #{body['message']}"
    assert body['message'].downcase.include?('desch, skiddiks, skiddiks'), 'Not all jobs listed'
    assert !body['message'].downcase.include?('arx-7'), 'Incorrect jobs listed'
  end

  test 'should succeed for correct show and ignore irrelevant show' do
    # Artificially set it as ready for release
    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: '123',
      auth: ENV['AUTH'],
      channel: '1',
      name: 'desch',
      format: :json
    }
    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('#2 released'), 'Incorrect success message'
  end

  test 'should release show based on term' do
    # Artificially set it as ready for release
    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: '123',
      auth: ENV['AUTH'],
      channel: '1',
      name: 'aoty',
      format: :json
    }
    assert_response 200
  end

  test 'should handle multiple show matches' do
    put :update, params: {
      username: '123',
      auth: ENV['AUTH'],
      channel: '1',
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
    show = Show.find_by(name: 'Kono Subarashii Sekai ni Shukufuku wo!')
    release = show.fansubs.first.current_release

    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: '123',
      auth: ENV['AUTH'],
      channel: '1',
      name: 'Subarashii',
      format: :json
    }

    assert_response 200

    # Reset (`release` is stale, need to query again)
    show.fansubs.first.releases.first.update_attribute :released, false

    put :update, params: {
      username: '456',
      auth: ENV['AUTH'],
      channel: '2',
      name: 'Subarashii',
      format: :json
    }

    assert_response 200
  end


  test 'should only allow Staff to release' do
    # Artificially set it as ready for release
    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, params: {
      username: '132434896',
      auth: ENV['AUTH'],
      channel: '1',
      name: 'aoty',
      format: :json
    }
    assert_response 404

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('user'),
           "Incorrect error message: #{body['message']}"
  end
end
