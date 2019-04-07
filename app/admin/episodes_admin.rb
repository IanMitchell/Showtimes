Trestle.resource(:episodes) do
  build_instance do |attrs, params|
    if params[:show_id]
      Episode.new(
        show: Show.find(params[:show_id]),
        number: params[:number],
        air_date: params[:air_date]
      )
    else
      Episode.new(attrs)
    end
  end

  form dialog: true do |episode|
    hidden_field :show_id

    number_field :number
    datetime_field :air_date
  end
end
