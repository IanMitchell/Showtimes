ActiveAdmin.register Group do
  menu parent: 'Group Management', priority: 1

  permit_params :name, :acronym

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
