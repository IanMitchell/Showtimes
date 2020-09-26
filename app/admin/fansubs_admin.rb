Trestle.resource(:fansubs) do
  menu do
    item :fansubs, icon: "fa fa-tv", group: :fansubs
  end

  collection do
    current_user.groups.collect(&:fansubs).flatten.uniq
  end

  table do
    column :id
    column :name
    column :airing, ->(fansub) { fansub.airing? }
    column :finished, -> (fansub) { fansub.finished? }
    column :visible

    actions
  end

  form do |fansub|
    if fansub.new_record?
      tab :fansub do
        text_field :name
        select :group_ids, current_user.groups
        number_field :episode_count
        number_field :first_episode_number
        check_box :visible
        datetime_field :air_date

        Position.all.each do |position|
          collection_select :default_staff,
                            Member.all,
                            Proc.new {|m| [position.id, m.id]},
                            :name,
                            { label: "#{position.name}(s)" },
                            { multiple: true }
        end
      end
    else
      tab :fansub do
        text_field :name
        check_box :visible
      end

      tab :releases, badge: fansub.releases.count do
        table fansub.releases, admin: :releases do
          column :id
          column :number
          column :air_date
          column :released
        end
      end

      tab :terms, badge: fansub.terms.count do
        table fansub.terms, admin: :terms do
          column :id
          column :name
        end

        concat admin_link_to(
          "Add Term",
          admin: :terms,
          action: :new,
          params: {
            fansub_id: instance.id,
          },
          class: "btn btn-success"
        )
      end

      tab :groups, badge: fansub.groups.count do
        table fansub.group_fansubs, admin: :group_fansubs do
          column :id
          column :group

          actions
        end

        concat admin_link_to(
          "Add Group",
          admin: :group_fansubs,
          action: :new,
          params: {
            fansub_id: instance.id,
          },
          class: "btn btn-success"
        )
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
  # form do |fansub|
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
  #   params.require(:fansub).permit(:name, ...)
  # end
end
