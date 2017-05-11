ActiveAdmin.register Account do
  menu parent: 'Group Management', priority: 4

  permit_params :user_id, :name, :platform
end
