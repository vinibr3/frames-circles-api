# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_30_202809) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "circles", force: :cascade do |t|
    t.bigint "frame_id", null: false
    t.decimal "x", null: false
    t.decimal "y", null: false
    t.decimal "radius", null: false
    t.decimal "diameter", null: false
    t.circle "geometry", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frame_id"], name: "index_circles_on_frame_id"
  end

  create_table "frames", force: :cascade do |t|
    t.decimal "x", null: false
    t.decimal "y", null: false
    t.decimal "width", null: false
    t.decimal "height", null: false
    t.box "geometry", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "highest_circle_id"
    t.bigint "lowest_circle_id"
    t.bigint "rightest_circle_id"
    t.bigint "leftest_circle_id"
    t.integer "circles_count", default: 0, null: false
    t.index ["highest_circle_id"], name: "index_frames_on_highest_circle_id"
    t.index ["leftest_circle_id"], name: "index_frames_on_leftest_circle_id"
    t.index ["lowest_circle_id"], name: "index_frames_on_lowest_circle_id"
    t.index ["rightest_circle_id"], name: "index_frames_on_rightest_circle_id"
  end

  add_foreign_key "circles", "frames"
  add_foreign_key "frames", "circles", column: "highest_circle_id"
  add_foreign_key "frames", "circles", column: "leftest_circle_id"
  add_foreign_key "frames", "circles", column: "lowest_circle_id"
  add_foreign_key "frames", "circles", column: "rightest_circle_id"
end
