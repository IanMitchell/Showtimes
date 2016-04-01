require "administrate/base_dashboard"

class VolumeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    show: Field::BelongsTo,
    episodes: Field::HasMany,
    releases: Field::HasMany,
    id: Field::Number,
    number: Field::Number,
    release_date: Field::DateTime,
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
    :episodes,
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
    :episodes,
    :releases,
    :number,
    :release_date,
  ]

  # Overwrite this method to customize how volumes are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(volume)
  #   "Volume ##{volume.id}"
  # end
end
