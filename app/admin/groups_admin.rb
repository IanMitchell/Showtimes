Trestle.resource(:groups) do
  menu do
    item :groups, icon: "fa fa-star", group: :core
  end

  collection do
    Group.order(id: :asc)
  end

  table do
    column :id
    column :name
    column :acronym
    column :slug
    column :webhook
  end

  form do |group|
    tab :group do
      text_field :name
      text_field :acronym
      text_field :webhook
    end

    tab :channels, badge: group.channels.count do
      table group.channels, admin: :channels do
        column :id
        column :group
        column :discord

        actions
      end

      concat admin_link_to(
        "New Channel",
        admin: :channels,
        action: :new,
        params: {
          group_id: instance.id,
        },
        class: "btn btn-success"
      )
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
  # form do |group|
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
  #   params.require(:group).permit(:name, ...)
  # end
end
