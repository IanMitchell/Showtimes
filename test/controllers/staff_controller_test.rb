require 'test_helper'

class StaffControllerTest < ActionController::TestCase
  test 'should ignore multiple matches for irrelevant shows' do
    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
      position: 'timer',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 200
  end

  test 'should restrict command to authorized requests' do
    put :update, params: {
      token: 'invalid_token',
      discord: 'cartel_discord',
      username: 'desch',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 401

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('token'),
           "Incorrect error message: #{body['message']}"
  end

  test 'should not allow non-staff users' do
    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'desch',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'desch',
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

  test 'should require position' do
    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'jukey',
      name: 'desch',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('specify a position'), 'Incorrect success message'
  end

  test 'should not allow incorrect staff position' do
    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'arx',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'desch',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'arx',
      name: 'desch',
      position: 'translator',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'arx',
      name: 'desch',
      position: 'translator',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
      position: 'timer',
      name: 'AOTY',
      status: 'true',
      format: :json
    }

    assert_response 200
  end

  test 'should handle multiple show matches' do
    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'arx',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'arx',
      name: 'Subarashii',
      position: 'editor',
      status: 'true',
      format: :json
    }

    assert_response 200

    put :update, params: {
      token: 'syndicate_token',
      discord: 'syndicate_discord',
      username: 'desch',
      name: 'Subarashii',
      position: 'tl',
      status: 'true',
      format: :json
    }

    assert_response 200
  end

  test 'should not allow accounts to mark joint shows on non-member discords' do
    put :update, params: {
      token: 'syndicate_token',
      discord: 'syndicate_discord',
      username: 'arx',
      position: 'editor',
      name: 'Subarashii',
      status: 'true',
      format: :json
    }

    assert_response 400
  end

  test 'should not allow updating an episode that has not aired yet' do
    put :update, params: {
      token: 'priority_test_token',
      discord: 'priority_discord',
      username: 'desch',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
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
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
      position: 'tm',
      name: 'AOTY',
      status: 'true',
      format: :json
    }

    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
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

  test "should restrict non-admins to their role for marking multi-purpose jobs" do
    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'skiddiks',
      position: 'tl',
      name: 'kuma',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].downcase.include?('already marked your position as complete')
  end

  test "should prioritize admins jobs when marking a job role for a multi-position job" do
    # Mark ARX as an admin
    group = Fansub.find_by(name: 'Kuma').groups.first
    member = Member.find_by(
      group: group,
      name: 'arx'
    )
    member.update_attribute :admin, true

    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'arx',
      position: 'tl',
      name: 'kuma',
      status: 'false',
      format: :json
    }

    assert_response 200

    staff = Fansub.find_by(name: 'Kuma')
      .current_release
      .staff
      .where(member: Member.find_by(name: 'arx', group: group))
      .first

    assert_equal staff.finished, false
  end

  test "should allow admins to mark non-job role as done for a multi-position job" do
    # Set second position as unfinished
    staff = Fansub.find_by(name: 'Kuma')
      .current_release
      .staff
      .where(member: Member.find_by(name: 'skiddiks'))
      .first

    staff.update_attribute :finished, false

    # Mark ARX as an admin
    member = Member.find_by(
      group: Fansub.find_by(name: 'Kuma').groups.first,
      name: 'arx'
    )
    member.update_attribute :admin, true

    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'arx',
      position: 'tl',
      name: 'kuma',
      status: 'true',
      format: :json
    }

    assert_response 200
    body = JSON.parse(response.body)
    assert body['message'].include?('Updated Kuma')
  end

  test "should alert all jobs are done for admin without a job" do
    put :update, params: {
      token: 'cartel_token',
      discord: 'cartel_discord',
      username: 'desch',
      position: 'tl',
      name: 'kuma',
      status: 'true',
      format: :json
    }

    assert_response 400

    body = JSON.parse(response.body)
    assert body['message'].include?('All Translator positions are marked that way already!')
  end

  test "staff marking position as finished should notify all group webhooks" do
  end

  test "staff marking position as unfinished should notify all group webhooks" do
  end

  test "should not update when staff status does not change" do
  end
end
