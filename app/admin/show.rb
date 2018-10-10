ActiveAdmin.register Show do
  menu parent: 'Data', priority: 1

  permit_params :name, :tvdb_name
end
