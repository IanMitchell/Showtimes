ActiveAdmin.register Release do
  menu parent: 'Subbing', priority: 2

  permit_params :fansub_id, :episode_id, :category, :station_id, :released
end
