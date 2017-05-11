ActiveAdmin.register Release do
  menu parent: 'Subbing', priority: 2

  permit_params :fansub_id, :source_id, :source_type, :category, :station_id, :released
end
