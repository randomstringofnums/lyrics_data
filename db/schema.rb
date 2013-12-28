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

ActiveRecord::Schema.define(version: 20131226220325) do

  create_table "albums", force: true do |t|
    t.integer "album_mbid"
    t.string  "album_name"
    t.integer "mxm_album_rating"
    t.date    "album_release_date"
    t.string  "first_primary_genre"
  end

  add_index "albums", ["album_release_date"], name: "index_albums_on_album_release_date"
  add_index "albums", ["id"], name: "index_albums_on_id"

  create_table "alt_brand_names", force: true do |t|
    t.integer "brand_id"
    t.string  "name"
  end

  add_index "alt_brand_names", ["brand_id"], name: "index_alt_brand_names_on_brand_id"

  create_table "brand_mentions", force: true do |t|
    t.integer "brand_id"
    t.integer "track_id"
    t.integer "alt_brand_name_id"
  end

  add_index "brand_mentions", ["brand_id"], name: "index_brand_mentions_on_brand_id"
  add_index "brand_mentions", ["track_id"], name: "index_brand_mentions_on_track_id"

  create_table "brands", force: true do |t|
    t.string  "name"
    t.integer "interbrand_rank_2013"
    t.integer "interbrand_rank_2012"
    t.string  "interbrand_country"
    t.string  "interbrand_sector"
  end

  create_table "deduped_tracks", force: true do |t|
    t.integer "track_id"
  end

  add_index "deduped_tracks", ["track_id"], name: "index_deduped_tracks_on_track_id"

  create_table "duplicate_tracks", id: false, force: true do |t|
    t.integer "id"
    t.string  "track_name"
    t.integer "mxm_track_rating"
    t.integer "dup_id"
    t.string  "dup_track_name"
    t.integer "dup_mxm_track_rating"
  end

  create_table "excludable_brands", force: true do |t|
    t.integer "brand_id"
    t.integer "score"
  end

  add_index "excludable_brands", ["brand_id"], name: "index_excludable_brands_on_brand_id"

  create_table "tracks", force: true do |t|
    t.string  "track_mbid"
    t.string  "track_name"
    t.integer "mxm_track_rating"
    t.integer "track_length"
    t.integer "album_id"
    t.string  "album_name"
    t.integer "artist_id"
    t.string  "artist_name"
    t.string  "photo_link"
  end

  add_index "tracks", ["album_id"], name: "index_tracks_on_album_id"
  add_index "tracks", ["artist_id"], name: "index_tracks_on_artist_id"

end
