class CreateInscripcions < ActiveRecord::Migration[8.0]
  def change
    create_table :inscripcions do |t|
      t.references :tipo_inscripcion, null: false, foreign_key: true
      t.references :campeonato, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :fecha_inscripcion, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :estado, null: false, default: 'activo'  # o enum si quieres

      t.timestamps
    end
  end
end
