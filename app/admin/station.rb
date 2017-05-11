ActiveAdmin.register Station do
  menu parent: 'Data', priority: 5

  permit_params :name
end
