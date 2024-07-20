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

ActiveRecord::Schema[7.1].define(version: 2024_07_20_123202) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formulas", force: :cascade do |t|
    t.string "name"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "result"
    t.index ["service_id"], name: "index_formulas_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contract_id"
    t.string "ancestry", null: false, collation: "C"
    t.index ["ancestry"], name: "index_services_on_ancestry"
    t.index ["contract_id"], name: "index_services_on_contract_id"
  end

  create_table "variables", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.bigint "formula_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formula_id"], name: "index_variables_on_formula_id"
  end

  add_foreign_key "formulas", "services"
  add_foreign_key "services", "contracts"
  add_foreign_key "variables", "formulas"
end
