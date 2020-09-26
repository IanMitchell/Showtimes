Trestle.resource(:terms) do
  build_instance do |attrs, params|
    if params[:fansub_id]
      Term.new(fansub: Fansub.find(params[:fansub_id]))
    else
      Term.new(attrs)
    end
  end

  form dialog: true do |term|
    hidden_field :fansub_id

    text_field :name
  end
end
