Trestle.resource(:channels) do
  build_instance do |attrs, params|
    if params[:group_id]
      Channel.new(group: Group.find(params[:group_id]))
    else
      Channel.new(attrs)
    end
  end

  form dialog: true do |episode|
    hidden_field :group_id

    text_field :discord
  end
end
