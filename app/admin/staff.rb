ActiveAdmin.register Staff do
  menu parent: 'Subbing', priority: 3

  permit_params :user_id, :position_id, :release_id, :finished
end
