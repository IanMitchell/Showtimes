ActiveAdmin.register Season do
  menu parent: 'Data', priority: 3

  permit_params :name, :year
end
