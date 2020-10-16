Trestle.resource(:members) do
  build_instance do |attrs, params|
    if params[:group_id]
      Member.new(group: Group.find(params[:group_id]))
    else
      Member.new(attrs)
    end
  end

  form dialog: true do |member|
    hidden_field :group_id

    text_field :name
    text_field :discord
    check_box :admin
  end
end
