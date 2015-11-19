require "administrate/base_dashboard"

class FansubDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    group: Field::BelongsTo,
    show: Field::BelongsTo,
    releases: Field::HasMany,
    id: Field::Number,
    tag: Field::String,
    nyaa_link: Field::String,
    status: EnumField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :group,
    :show,
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
    :group,
    :show,
    :releases,
    :tag,
    :nyaa_link,
    :status,
  ]

  # Overwrite this method to customize how fansubs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(fansub)
  #   "Fansub ##{fansub.id}"
  # end
end
