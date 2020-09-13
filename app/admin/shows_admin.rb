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

    actions
  end

  form do |show|
    tab :show do
      text_field :name
      text_field :tvdb_name

      if show.new_record?
        number_field :episode_count
        number_field :first_episode_number, default: 0
        datetime_field :air_date
      end
    end

    unless show.new_record?
      tab :episodes, badge: show.episodes.count do
        table show.episodes, admin: :episodes do
          column :id
          column :show
          column :number, sort: { default: true, default_order: :asc }
          column :air_date

          actions
        end

        concat admin_link_to(
          "New Episode",
          admin: :episodes,
          action: :new,
          params: {
            show_id: instance.id,
            number: instance.episodes.count + 1,
            air_date: instance.episodes.last.air_date + 1.week
          },
          class: "btn btn-success"
        )
      end

      tab :terms, badge: show.terms.count do
        table show.terms, admin: :terms do
          column :id
          column :show
          column :name

          actions
        end

        concat admin_link_to(
          "New Term",
          admin: :terms,
          action: :new,
          params: {
            show_id: instance.id,
          },
          class: "btn btn-success"
        )
      end
    end
  end
end
