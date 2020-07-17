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

ActiveRecord::Schema.define(version: 2020_07_13_053734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string "paypal_order_id"
    t.string "items", default: [], array: true
    t.string "deliver_status"
    t.string "payment_status"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "paypal_plans", force: :cascade do |t|
    t.string "external_id"
    t.string "name"
    t.string "description"
    t.integer "regular_price"
    t.integer "week_experience_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_prices", force: :cascade do |t|
    t.string "kind"
    t.string "prices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "regular_price"
    t.integer "week_experience_price"
    t.integer "regular_classes_per_week"
    t.integer "private_lessons_per_month"
    t.bigint "paypal_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paypal_plan_id"], name: "index_plans_on_paypal_plan_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "paypal_subscription_id"
    t.date "last_paid_at"
    t.date "expiration_date"
    t.date "next_billing_at"
    t.string "status"
    t.string "status_changes"
    t.string "status_changes_attempts"
    t.string "payment_status"
    t.string "payment_status_changes"
    t.string "payment_status_changes_attempts"
    t.bigint "user_id"
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
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

  add_foreign_key "orders", "users"
  add_foreign_key "plans", "paypal_plans"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
end
