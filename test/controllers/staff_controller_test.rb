require 'test_helper'

class StaffControllerTest < ActionController::TestCase
  test 'should restrict command to authorized requests' do
    put :update, {
      auth: 'lolno',
      irc: '#cartel',
      username: 'Desch',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('unauthorized'), 'Incorrect error message'
  end

  test 'should not allow non-staff channels' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel',
      username: 'Desch',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('channel'), 'Incorrect error message'
  end

  test 'should not allow non-staff nicks' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'Belfiore',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('nick'), 'Incorrect error message'
  end

  test 'should not allow non-fansubbed shows' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'Desch',
      name: "Full Metal Panic! The Second Raid",
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('no staff'), 'Incorrect error message'
  end

  test 'should not allow non-staff to update show' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'Jukey',
      name: 'aoty',
      position: 'qc',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('not your position'), 'Incorrect error message'
  end

  test 'should not allow invalid positions' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'Desch',
      name: 'aoty',
      position: 'memer',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('invalid position'), 'Incorrect error message'
  end

  test 'should not require position when user has one position' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'ARX-7',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'
  end

  test 'should require position when user has multiple positions' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'skiddiks',
      name: 'aoty',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('specify position'), 'Incorrect error message'
  end

  test 'should not allow incorrect staff position' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'ARX-7',
      name: 'aoty',
      position: 'editor',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('not your position'), 'Incorrect success message'
  end

  test 'should allow founders to update any position for any show' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'Desch',
      name: 'aoty',
      position: 'translator',
      status: 'true',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Translator')).first

    assert staff.finished, 'Staff not updated correctly'
  end

  test 'should correctly update show' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'ARX-7',
      name: 'aoty',
      position: 'translator',
      status: 'true',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Translator')).first

    assert staff.finished, 'Staff not updated correctly'
  end

  test 'should correctly revert staff as unfinished' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'ARX-7',
      name: 'aoty',
      position: 'translator',
      status: 'true',
      format: :json
    }

    assert_response 200

    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'ARX-7',
      name: 'aoty',
      status: 'false',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Translator')).first

    assert !staff.finished, 'Staff not updated correctly'
  end

  test 'should handle marking staff as unfinished when unfinished' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'ARX-7',
      name: 'aoty',
      status: 'false',
      format: :json
    }

    assert_response 200

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('updated'), 'Incorrect success message'

    show = Show.find_by(name: "Desch's Slice of Life")
    release = show.fansubs.first.current_release
    staff = release.staff.where(position: Position.find_by(name: 'Translator')).first

    assert !staff.finished, 'Staff not updated correctly'
  end

  test 'should update current release' do
    put :update, {
      auth: ENV['AUTH'],
      irc: '#cartel-staff',
      username: 'ARX-7',
      name: 'aoty',
      position: 'translator',
      status: 'true',
      format: :json
    }

    assert_response 200

    show = Show.find_by(name: "Desch's Slice of Life")
    release = Release.find_by(source: Episode.find_by(show: show,
                                                      number: 2))
    staff = Staff.where(user: User.find_by(name: 'ARX-7'),
                        release: release,
                        position: Position.find_by(name: 'Translator'))

    assert staff.finished, 'Incorrect staff entry modified'
  end
end
