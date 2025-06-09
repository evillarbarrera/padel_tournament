class CreateParejas < ActiveRecord::Migration[8.0]
  def change
    create_table :parejas do |t|
    t.references :inscripcion_1, foreign_key: { to_table: :inscripcions }
    t.references :inscripcion_2, foreign_key: { to_table: :inscripcions }

      t.string :estado, default: "pendiente"

      t.timestamps
    end
  end
end
