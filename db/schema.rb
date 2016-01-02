# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160102204019) do

  create_table "aliases", force: :cascade do |t|
    t.integer  "show_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "aliases", ["show_id"], name: "index_aliases_on_show_id"

  create_table "channels", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "episodes", force: :cascade do |t|
    t.integer  "show_id"
    t.integer  "volume_id"
    t.integer  "number"
    t.datetime "air_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "episodes", ["show_id"], name: "index_episodes_on_show_id"
  add_index "episodes", ["volume_id"], name: "index_episodes_on_volume_id"

  create_table "fansubs", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "show_id"
    t.string   "tag"
    t.string   "nyaa_link"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "fansubs", ["group_id"], name: "index_fansubs_on_group_id"
  add_index "fansubs", ["show_id"], name: "index_fansubs_on_show_id"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "acronym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.string   "public_irc"
    t.string   "staff_irc"
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true

  create_table "members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "status",     default: 0
    t.integer  "role",       default: 0
    t.string   "title"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "members", ["group_id"], name: "index_members_on_group_id"
  add_index "members", ["user_id"], name: "index_members_on_user_id"

  create_table "positions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "acronym"
  end

  create_table "releases", force: :cascade do |t|
    t.integer  "fansub_id"
    t.integer  "channel_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "status",      default: 0
    t.integer  "category",    default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "releases", ["channel_id"], name: "index_releases_on_channel_id"
  add_index "releases", ["fansub_id"], name: "index_releases_on_fansub_id"
  add_index "releases", ["source_type", "source_id"], name: "index_releases_on_source_type_and_source_id"

  create_table "seasons", force: :cascade do |t|
    t.integer  "name",       default: 0
    t.integer  "year"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "shows", force: :cascade do |t|
    t.integer  "season_id"
    t.string   "name"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "shows", ["season_id"], name: "index_shows_on_season_id"

  create_table "staff", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "position_id"
    t.integer  "release_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "staff", ["position_id"], name: "index_staff_on_position_id"
  add_index "staff", ["release_id"], name: "index_staff_on_release_id"
  add_index "staff", ["user_id"], name: "index_staff_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "irc_nick"
    t.string   "twitter"
    t.string   "timezone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "volumes", force: :cascade do |t|
    t.integer  "show_id"
    t.integer  "number"
    t.datetime "release_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "volumes", ["show_id"], name: "index_volumes_on_show_id"

end
