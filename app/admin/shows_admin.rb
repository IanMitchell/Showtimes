Trestle.resource(:shows) do
  collection do
    Show.order(id: :desc)
  end

  menu do
    item :shows, icon: "fa fa-star", group: :anime, priority: :first
  end

  table do
    column :id
    column :name
    column :episodes do |instance|
      instance.episodes.count
    end
    column :tvdb_name
  end

  form do |show|
    tab :show do
      text_field :name
      text_field :tvdb_name
    end

    tab :episodes, badge: show.episodes.count do
      table show.episodes, admin: :episodes do
        column :id
        column :show
        column :number, sort: { default: true, default_order: :asc }
        column :air_date

        actions
      end
    end

    tab :aliases, badge: show.aliases.count do
      table show.aliases, admin: :aliases do
        column :id
        column :show
        column :name

        actions
      end
    end
  end

  # Customize the table columns shown on the index view.
  #
  # table do
  #   column :name
  #   column :created_at, align: :center
  #   actions
  # end

  # Customize the form fields shown on the new/edit views.
  #
  # form do |show|
  #   text_field :name
  #
  #   row do
  #     col(xs: 6) { datetime_field :updated_at }
  #     col(xs: 6) { datetime_field :created_at }
  #   end
  # end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:show).permit(:name, ...)
  # end
end
