# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_16_051017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administrators_groups", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "administrator_id"
    t.index ["administrator_id"], name: "index_administrators_groups_on_administrator_id"
    t.index ["group_id"], name: "index_administrators_groups_on_group_id"
  end

  create_table "channels", id: :serial, force: :cascade do |t|
    t.string "discord", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discord"], name: "index_channels_on_discord"
    t.index ["group_id"], name: "index_channels_on_group_id"
  end

  create_table "fansubs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.boolean "visible", default: true
    t.index ["name"], name: "index_fansubs_on_name"
    t.index ["visible"], name: "index_fansubs_on_visible"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "group_fansubs", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "fansub_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fansub_id"], name: "index_group_fansubs_on_fansub_id"
    t.index ["group_id"], name: "index_group_fansubs_on_group_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "acronym", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "webhook"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "discord", null: false
    t.boolean "admin", default: false
    t.bigint "group_id"
    t.index ["discord"], name: "index_members_on_discord"
    t.index ["group_id"], name: "index_members_on_group_id"
  end

  create_table "positions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "acronym", null: false
    t.index ["acronym"], name: "index_positions_on_acronym"
    t.index ["name"], name: "index_positions_on_name"
  end

  create_table "releases", id: :serial, force: :cascade do |t|
    t.integer "fansub_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "released", default: false
    t.integer "number", null: false
    t.datetime "air_date", null: false
    t.index ["air_date"], name: "index_releases_on_air_date"
    t.index ["fansub_id"], name: "index_releases_on_fansub_id"
    t.index ["number"], name: "index_releases_on_number"
    t.index ["released"], name: "index_releases_on_released"
  end

  create_table "staff", id: :serial, force: :cascade do |t|
    t.integer "position_id"
    t.integer "release_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "finished", default: false
    t.bigint "member_id"
    t.index ["finished"], name: "index_staff_on_finished"
    t.index ["member_id"], name: "index_staff_on_member_id"
    t.index ["position_id"], name: "index_staff_on_position_id"
    t.index ["release_id"], name: "index_staff_on_release_id"
  end

  create_table "terms", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "fansub_id", null: false
    t.index ["fansub_id"], name: "index_terms_on_fansub_id"
    t.index ["name"], name: "index_terms_on_name"
  end

  add_foreign_key "group_fansubs", "fansubs"
  add_foreign_key "group_fansubs", "groups"
  add_foreign_key "members", "groups"
  add_foreign_key "terms", "fansubs"
end
