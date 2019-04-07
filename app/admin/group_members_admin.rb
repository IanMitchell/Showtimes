Trestle.resource(:group_members) do
  build_instance do |attrs, params|
    if params[:group_id]
      GroupMember.new(group: Group.find(params[:group_id]))
    else
      GroupMember.new(attrs)
    end
  end

  form dialog: true do |group_member|
    hidden_field :group_id

    select :member_id, Member.all
  end
end
