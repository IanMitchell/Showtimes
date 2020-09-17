Trestle.resource(:group_fansubs) do
  build_instance do |attrs, params|
    if params[:fansub_id]
      GroupFansub.new(fansub: Fansub.find(params[:fansub_id]))
    else
      GroupFansub.new(attrs)
    end
  end

  form dialog: true do |group_fansub|
    hidden_field :fansub_id

    select :group_id, current_user.groups
  end
end
