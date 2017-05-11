ActiveAdmin.register Fansub do
  menu parent: 'Subbing', priority: 1

  permit_params :show_id, :status
end
