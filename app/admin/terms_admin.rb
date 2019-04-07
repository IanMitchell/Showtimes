Trestle.resource(:terms) do
  build_instance do |attrs, params|
    if params[:show_id]
      Term.new(show: Show.find(params[:show_id]))
    else
      Term.new(attrs)
    end
  end

  form dialog: true do |term|
    hidden_field :show_id

    text_field :name
  end
end
