class CreateParejas < ActiveRecord::Migration[8.0]
  def change
    create_table :parejas do |t|
      t.references :inscripcion_1, null: false, foreign_key: { to_table: :inscripciones }
      t.references :inscripcion_2, null: false, foreign_key: { to_table: :inscripciones }
      t.string :estado, default: "pendiente"

      t.timestamps
    end
  end
end
