require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  test 'should require authentication' do
    put :update, {
      username: 'Desch',
      auth: 'wrongpassword',
      irc: '#gjm',
      name: 'desch',
      format: :json
    }
    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unauthorized'), 'Incorrect error message'
  end

  test 'should fail with incorrect channel' do
    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#gjm',
      name: 'desch',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('channel'), 'Incorrect error message'
  end

  test 'should fail with non-staff channel' do
    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel',
      name: 'desch',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('channel'), 'Incorrect error message'
  end

  test 'should fail with incorrect show' do
    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'aoty2',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unknown show'), 'Incorrect error message'
  end

  test 'should fail with incorrect fansub' do
    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'fmp',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('associated fansub'), 'Incorrect error message'
  end

  test 'should fail with finished show' do
    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'kimi no uso',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('no pending'), 'Incorrect error message'
  end

  test 'should require all positions to be complete' do
    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'desch',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('still pending'), 'Incorrect error message'
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

    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'desch',
      format: :json
    }
    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('#2 released'), 'Incorrect success message'
  end

  test 'should release show based on alias' do
    # Artificially set it as ready for release
    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'aoty',
      format: :json
    }
    assert_response 200
  end

  test 'should handle multiple show matches' do
    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'shigatsu',
      format: :json
    }
    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('matches'), 'Incorrect error message'
  end

  test 'should support joint shows' do
    # Artificially set it as ready for release
    show = Show.find_by(name: 'Kono Subarashii Sekai ni Shukufuku wo!')
    release = show.fansubs.first.current_release
    release.staff.each do |staff|
      staff.update_attribute :finished, true
    end

    put :update, {
      username: 'Desch',
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      name: 'Subarashii',
      format: :json
    }

    assert_response 200

    # Reset
    show.fansubs.first.releases.first.update_attribute :released, false

    put :update, {
      username: 'ARX',
      auth: ENV['AUTH'],
      irc: '#syndicate-staff',
      name: 'Subarashii',
      format: :json
    }

    assert_response 200
  end
end
