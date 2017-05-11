ActiveAdmin.register Position do
  menu parent: 'Data', priority: 6

  permit_params :name, :acronym
end
