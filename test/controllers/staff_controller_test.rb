require 'test_helper'

class StaffControllerTest < ActionController::TestCase
  test 'should ignore multiple matches for irrelevant shows' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      position: 'timer',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 200
  end

  test 'should restrict command to authorized requests' do
    put :update, params: {
      auth: 'lolno',
      channel: 'cartel_discord',
      username: '123',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unauthorized'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not allow non-staff users' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '486',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 404

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('user'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not allow non-fansubbed shows' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '123',
      name: "Full Metal Panic! The Second Raid",
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('no associated fansub'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not allow non-staff to update show' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: 'fyurie',
      name: 'desch',
      position: 'qc',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('not your position'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not allow non-members to update show' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: 'areki',
      name: 'desch',
      position: 'qc',
      status: 'true',
      format: :json
    }

    assert_response 404

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('have a group admin authorize'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not allow invalid positions' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '123',
      name: 'desch',
      position: 'memer',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('invalid position'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not require position when user has one position' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '1213',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'
  end

  test 'should require position when user has multiple positions' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('specify position'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not allow incorrect staff position' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '456',
      name: 'desch',
      position: 'editor',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('not your position'), 'Incorrect success message'
  end

  test 'should allow founders to update any position for any show' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '123',
      name: 'desch',
      position: 'timer',
      status: 'true',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    release = Fansub.where(name: "Desch's Slice of Life").first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Timer')).first

    assert staff.finished, 'Staff not updated correctly'
  end

  test 'should correctly update show' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      name: 'desch',
      position: 'timer',
      status: 'true',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    release = Fansub.where(name: "Desch's Slice of Life").first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Timer')).first

    assert staff.finished, 'Staff not updated correctly'
  end

  test 'should correctly revert staff as unfinished' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '456',
      name: 'desch',
      status: 'false',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    release = Fansub.where(name: "Desch's Slice of Life").first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Translator')).first

    assert !staff.finished, 'Staff not updated correctly'
  end

  test 'should handle marking staff as unfinished when finished' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '456',
      name: 'desch',
      status: 'false',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    release = Fansub.where(name: "Desch's Slice of Life").first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Translator')).first

    assert !staff.finished, 'Staff not updated correctly'
  end

  test 'should update current release' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      name: 'desch',
      position: 'timer',
      status: 'true',
      format: :json
    }

    assert_response 200

    fansub = Fansub.where(name: "Desch's Slice of Life").first
    release = Release.find_by(fansub: fansub, number: 2)
                                                           
    staff = Staff.where(member: Member.find_by(name: 'skiddiks'),
                        release: release,
                        position: Position.find_by(name: 'Timer'))

    assert staff.finished, 'Incorrect staff entry modified'
  end

  test 'should update show based on term' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      position: 'timer',
      name: 'AOTY',
      status: 'true',
      format: :json
    }

    assert_response 200
  end

  test 'should handle multiple show matches' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '456',
      name: 'shigatsu',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('match'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should support joint shows' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '456',
      name: 'Subarashii',
      status: 'true',
      format: :json
    }

    assert_response 200

    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'syndicate_discord',
      username: '123',
      name: 'Subarashii',
      position: 'tl',
      status: 'true',
      format: :json
    }

    assert_response 200
  end

  test 'should not allow updating an episode that has not aired yet' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'priority_discord',
      username: '123',
      name: 'Kagooya',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('not aired yet'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should alert user if progress already set' do
    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      position: 'tm',
      name: 'AOTY',
      status: 'false',
      format: :json
    }

    assert_response 400
    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('already marked your position as incomplete'),
           "Incorrect alert message: #{body['message']}"

    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      position: 'tm',
      name: 'AOTY',
      status: 'true',
      format: :json
    }

    put :update, params: {
      auth: ENV['AUTH'],
      channel: 'cartel_discord',
      username: '789',
      position: 'tm',
      name: 'AOTY',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('already marked your position as complete'),
            "Incorrect alert message: #{body['message']}"
  end
end
