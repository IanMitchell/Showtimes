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

    unless group.new_record?
      tab :members, badge: group.members.count do
        table group.group_members, admin: :group_members do
          column :id
          column :member
          column :admin

          actions
        end

        concat admin_link_to(
          "Add Member",
          admin: :group_members,
          action: :new,
          params: {
            group_id: instance.id,
          },
          class: "btn btn-success"
        )
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
  end
end
