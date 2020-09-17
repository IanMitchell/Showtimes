Trestle.resource(:releases) do
  collection do
    current_user.groups.collect(&:fansubs).flatten.uniq.collect(&:releases).flatten.uniq
  end

  table do
    column :id
    column :fansub
    column :number
    column :air_date
    column :released
  end

  form do |release|
    tab :release do
      number_field :number
      datetime_field :air_date

      check_box :released
    end

    tab :staff, badge: release.staff.count do
      table release.staff, admin: :staff do
        column :id
        column :position
        column :member
        column :finished

        actions
      end

      concat admin_link_to(
        "New Staff",
        admin: :staff,
        action: :new,
        params: {
          release_id: instance.id,
        },
        class: "btn btn-success"
      )
    end
  end
end
