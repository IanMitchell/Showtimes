Trestle.resource(:positions, readonly: true) do

  menu do
    item :positions, icon: "fa fa-map-marker", group: :core, priority: 2
  end

  table do
    row data: { url: nil }
    column :id
    column :name
    column :acronym
  end
end
