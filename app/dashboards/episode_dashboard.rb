require "administrate/base_dashboard"

class EpisodeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    show: Field::BelongsTo,
    volume: Field::BelongsTo,
    releases: Field::HasMany,
    id: Field::Number,
    number: Field::Number,
    air_date: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :show,
    :volume,
    :releases,
    :id,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :show,
    :volume,
    :releases,
    :number,
    :air_date,
  ]

  # Overwrite this method to customize how episodes are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(episode)
  #   "Episode ##{episode.id}"
  # end
  def display_resource(episode)
    "Ep ##{episode.number}"
  end
end
