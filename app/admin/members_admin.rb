Trestle.resource(:members) do
  menu do
    item :members, icon: "fa fa-star", group: :fansubs
  end

  table do
    column :id
    column :name
    column :discord
  end

  form do |member|
    text_field :name
    text_field :discord
  end
end
