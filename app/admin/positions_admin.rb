Trestle.resource(:positions) do
  menu do
    item :positions, icon: "fa fa-star", group: :core, priority: 2
  end

  table do
    column :id
    column :name
    column :acronym
  end

  form do |position|
    text_field :name
    text_field :acronym
  end
end
