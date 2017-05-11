ActiveAdmin.register Member do
  menu parent: 'Group Management', priority: 3

  permit_params :group_id, :user_id, :role, :title
end
