require "administrate/base_dashboard"

class ReleaseDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    source: Field::Polymorphic,
    fansub: Field::BelongsTo,
    station: Field::BelongsTo,
    staff: Field::HasMany,
    id: Field::Number,
    category: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    released: Field::Boolean,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :fansub,
    :source,
    :staff
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :source,
    :fansub,
    :station,
    :staff,
    :category,
    :released,
  ]

  # Overwrite this method to customize how releases are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(release)
  #   "Release ##{release.id}"
  # end
  def display_resource(release)
    "#{release.fansub.group.acronym} #{release.source.name} ##{release.source.number}"
  end
end
