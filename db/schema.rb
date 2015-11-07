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

ActiveRecord::Schema.define(version: 20151107022722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees_organizations", id: false, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "organization_id"
  end

  add_index "employees_organizations", ["employee_id"], name: "index_employees_organizations_on_employee_id", using: :btree
  add_index "employees_organizations", ["organization_id"], name: "index_employees_organizations_on_organization_id", using: :btree

  create_table "employees_repos", id: false, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "repo_id"
  end

  add_index "employees_repos", ["employee_id"], name: "index_employees_repos_on_employee_id", using: :btree
  add_index "employees_repos", ["repo_id"], name: "index_employees_repos_on_repo_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repos", force: :cascade do |t|
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
  end

end
