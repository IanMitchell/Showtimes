ActiveAdmin.register Channel do
  menu parent: 'Group Management', priority: 2

  permit_params :name, :group_id, :staff, :platform
end
