# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_10_195759) do

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
    t.string "first_name"
    t.string "last_name"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aliases", id: :serial, force: :cascade do |t|
    t.integer "show_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_aliases_on_name"
    t.index ["show_id"], name: "index_aliases_on_show_id"
  end

  create_table "channels", id: :serial, force: :cascade do |t|
    t.string "discord"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discord"], name: "index_channels_on_discord"
    t.index ["group_id"], name: "index_channels_on_group_id"
  end

  create_table "episodes", id: :serial, force: :cascade do |t|
    t.integer "show_id"
    t.integer "number"
    t.datetime "air_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
    t.index ["season_id"], name: "index_episodes_on_season_id"
    t.index ["show_id"], name: "index_episodes_on_show_id"
  end

  create_table "fansubs", id: :serial, force: :cascade do |t|
    t.integer "show_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id"], name: "index_fansubs_on_show_id"
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
    t.integer "group_id"
    t.integer "fansub_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fansub_id"], name: "index_group_fansubs_on_fansub_id"
    t.index ["group_id"], name: "index_group_fansubs_on_group_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "webhook"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "discord"
    t.index ["group_id"], name: "index_members_on_group_id"
  end

  create_table "positions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "acronym"
    t.index ["acronym"], name: "index_positions_on_acronym"
    t.index ["name"], name: "index_positions_on_name"
  end

  create_table "releases", id: :serial, force: :cascade do |t|
    t.integer "fansub_id"
    t.integer "category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "station_id"
    t.boolean "released", default: false
    t.bigint "episode_id"
    t.index ["episode_id"], name: "index_releases_on_episode_id"
    t.index ["fansub_id"], name: "index_releases_on_fansub_id"
    t.index ["station_id"], name: "index_releases_on_station_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.integer "name", default: 0
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shows", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tvdb_name"
    t.index ["name"], name: "index_shows_on_name"
  end

  create_table "staff", id: :serial, force: :cascade do |t|
    t.integer "position_id"
    t.integer "release_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "finished", default: false
    t.bigint "memberr_id"
    t.index ["memberr_id"], name: "index_staff_on_memberr_id"
    t.index ["position_id"], name: "index_staff_on_position_id"
    t.index ["release_id"], name: "index_staff_on_release_id"
  end

  create_table "stations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "episodes", "seasons"
  add_foreign_key "group_fansubs", "fansubs"
  add_foreign_key "group_fansubs", "groups"
end
