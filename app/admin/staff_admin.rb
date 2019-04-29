Trestle.resource(:staff) do
  build_instance do |attrs, params|
    if params[:release_id]
      Staff.new(release: Release.find(params[:release_id]))
    else
      Staff.new(attrs)
    end
  end

  form dialog: true do |episode|
    hidden_field :release_id

    select :position_id, Position.all
    select :member_id, Member.all
    check_box :finished
  end

  return_to on: :destroy do |instance|
    edit_fansubs_admin_path instance.release.fansub
  end
end
