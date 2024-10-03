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

ActiveRecord::Schema[7.1].define(version: 2024_09_20_203530) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formulas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "result"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
    t.bigint "contract_id"
    t.index ["contract_id"], name: "index_invoices_on_contract_id"
  end

  create_table "order_variables", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.boolean "operator"
    t.boolean "fixed"
    t.string "value"
    t.string "role"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_variables_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invoice_id"
    t.string "ancestry", null: false, collation: "C"
    t.text "description"
    t.index ["ancestry"], name: "index_orders_on_ancestry"
    t.index ["invoice_id"], name: "index_orders_on_invoice_id"
    t.index ["service_id"], name: "index_orders_on_service_id"
  end

  create_table "orders_taxes", id: false, force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "tax_id"
    t.index ["order_id"], name: "index_orders_taxes_on_order_id"
    t.index ["tax_id"], name: "index_orders_taxes_on_tax_id"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contract_id"
    t.string "ancestry", null: false, collation: "C"
    t.text "description"
    t.boolean "agency_fee"
    t.integer "value"
    t.index ["ancestry"], name: "index_services_on_ancestry"
    t.index ["contract_id"], name: "index_services_on_contract_id"
  end

  create_table "services_tax_regimes", id: false, force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "tax_regime_id"
    t.index ["service_id"], name: "index_services_tax_regimes_on_service_id"
    t.index ["tax_regime_id"], name: "index_services_tax_regimes_on_tax_regime_id"
  end

  create_table "tax_regimes", force: :cascade do |t|
    t.string "name"
    t.integer "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contract_id"
    t.boolean "isfee"
    t.index ["contract_id"], name: "index_tax_regimes_on_contract_id"
  end

  create_table "taxes", force: :cascade do |t|
    t.string "name"
    t.integer "percentage"
    t.boolean "isfee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invoice_id"
    t.index ["invoice_id"], name: "index_taxes_on_invoice_id"
  end

  create_table "variables", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.integer "position"
    t.boolean "operator"
    t.boolean "fixed"
    t.string "role"
    t.index ["service_id"], name: "index_variables_on_service_id"
  end

  add_foreign_key "invoices", "contracts"
  add_foreign_key "order_variables", "orders"
  add_foreign_key "orders", "invoices"
  add_foreign_key "orders", "services"
  add_foreign_key "services", "contracts"
  add_foreign_key "tax_regimes", "contracts"
  add_foreign_key "taxes", "invoices"
  add_foreign_key "variables", "services"
end
