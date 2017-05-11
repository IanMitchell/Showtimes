ActiveAdmin.register Episode do
  menu parent: 'Data', priority: 2

  permit_params :show_id, :number, :air_date, :season_id
end
