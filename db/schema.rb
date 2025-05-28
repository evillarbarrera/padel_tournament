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

ActiveRecord::Schema[8.0].define(version: 2025_05_28_175549) do
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

  create_table "campeonatos", force: :cascade do |t|
    t.integer "club_id", null: false
    t.integer "categoria_id", null: false
    t.string "nombre"
    t.text "descripcion"
    t.string "foto"
    t.text "normativo"
    t.string "tipo"
    t.date "fecha_inicio"
    t.date "fecha_termino"
    t.integer "cupos_maximos"
    t.string "estado"
    t.text "reglas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_campeonatos_on_categoria_id"
    t.index ["club_id"], name: "index_campeonatos_on_club_id"
  end

  create_table "categoria", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clubs", force: :cascade do |t|
    t.string "nombre"
    t.string "direccion"
    t.string "telefono"
    t.string "email"
    t.string "logo"
    t.datetime "fecha_creacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer "club_id"
    t.integer "user_id", null: false
    t.string "nombre"
    t.string "estado"
    t.datetime "fecha_creacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_roles_on_club_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name"
    t.string "job_class"
    t.text "arguments"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "active_job_id"
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["queue_name"], name: "index_solid_queue_jobs_on_queue_name"
    t.index ["run_at"], name: "index_solid_queue_jobs_on_run_at"
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "pid"
    t.string "hostname"
    t.string "worker_name"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_inscripcions", force: :cascade do |t|
    t.string "nombre"
    t.integer "monto"
    t.date "fecha_limite_pago"
    t.text "beneficios"
    t.integer "campeonato_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campeonato_id"], name: "index_tipo_inscripcions_on_campeonato_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nombre"
    t.string "telefono"
    t.string "categoria"
    t.integer "puntos", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foto"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campeonatos", "categoria", column: "categoria_id"
  add_foreign_key "campeonatos", "clubs"
  add_foreign_key "roles", "clubs"
  add_foreign_key "roles", "users"
  add_foreign_key "tipo_inscripcions", "campeonatos"
end
