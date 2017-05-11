ActiveAdmin.register Alias do
  menu parent: 'Data', priority: 4

  permit_params :name, :show_id
end
