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

ActiveRecord::Schema[7.1].define(version: 2025_03_17_205752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "supplier_id"
    t.index ["supplier_id"], name: "index_contracts_on_supplier_id"
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
    t.bigint "purchase_order_id"
    t.string "good_receipt"
    t.date "payment_date"
    t.integer "budget_price"
    t.integer "invoice_price"
    t.index ["contract_id"], name: "index_invoices_on_contract_id"
    t.index ["purchase_order_id"], name: "index_invoices_on_purchase_order_id"
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
    t.decimal "net", default: "0.0"
    t.decimal "gross", default: "0.0"
    t.text "comment"
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

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value"
    t.date "date"
    t.bigint "purchase_order_id"
    t.index ["purchase_order_id"], name: "index_payments_on_purchase_order_id"
  end

  create_table "po_lines", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "value", default: 0
    t.bigint "purchase_order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_order_id"], name: "index_po_lines_on_purchase_order_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commodity"
    t.string "category"
    t.boolean "completed", default: false
    t.boolean "archived", default: false
    t.string "box_link"
    t.text "todo"
    t.boolean "require_sourcing", default: true
    t.string "image"
    t.bigint "user_id", null: false
    t.bigint "supplier_id"
    t.bigint "purchase_order_id"
    t.index ["purchase_order_id"], name: "index_projects_on_purchase_order_id"
    t.index ["supplier_id"], name: "index_projects_on_supplier_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
    t.integer "budget"
    t.bigint "contract_id"
    t.integer "spend", default: 0
    t.index ["contract_id"], name: "index_purchase_orders_on_contract_id"
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
    t.decimal "net", default: "0.0"
    t.decimal "gross", default: "0.0"
    t.index ["ancestry"], name: "index_services_on_ancestry"
    t.index ["contract_id"], name: "index_services_on_contract_id"
  end

  create_table "services_tax_regimes", id: false, force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "tax_regime_id"
    t.index ["service_id"], name: "index_services_tax_regimes_on_service_id"
    t.index ["tax_regime_id"], name: "index_services_tax_regimes_on_tax_regime_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "contact"
    t.boolean "cw", default: false
    t.integer "external_id"
  end

  create_table "tax_regimes", force: :cascade do |t|
    t.string "name"
    t.decimal "percentage", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contract_id"
    t.boolean "isfee"
    t.index ["contract_id"], name: "index_tax_regimes_on_contract_id"
  end

  create_table "taxes", force: :cascade do |t|
    t.string "name"
    t.decimal "percentage", default: "0.0"
    t.boolean "isfee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invoice_id"
    t.index ["invoice_id"], name: "index_taxes_on_invoice_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contracts", "suppliers"
  add_foreign_key "invoices", "contracts"
  add_foreign_key "invoices", "purchase_orders"
  add_foreign_key "order_variables", "orders"
  add_foreign_key "orders", "invoices"
  add_foreign_key "orders", "services"
  add_foreign_key "payments", "purchase_orders"
  add_foreign_key "po_lines", "purchase_orders"
  add_foreign_key "projects", "users"
  add_foreign_key "purchase_orders", "contracts"
  add_foreign_key "services", "contracts"
  add_foreign_key "tax_regimes", "contracts"
  add_foreign_key "taxes", "invoices"
  add_foreign_key "variables", "services"
end
