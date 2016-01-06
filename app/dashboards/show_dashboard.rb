require "administrate/base_dashboard"

class ShowDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    season: Field::BelongsTo,
    fansubs: Field::HasMany,
    aliases: Field::HasMany,
    episodes: Field::HasMany,
    volumes: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    link: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :season,
    :fansubs,
    :aliases,
    :episodes,
    :volumes,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :season,
    :fansubs,
    :aliases,
    :episodes,
    :volumes,
    :name,
    :link,
  ]

  # Overwrite this method to customize how shows are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(show)
  #   "Show ##{show.id}"
  # end
  def display_resource(show)
    show.name
  end
end
