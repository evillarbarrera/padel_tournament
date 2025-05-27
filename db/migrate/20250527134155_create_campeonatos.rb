class CreateCampeonatos < ActiveRecord::Migration[8.0]
  def change
    create_table :campeonatos do |t|
      t.references :club, null: false, foreign_key: true
      t.references :categoria, null: false, foreign_key: true
      t.references :tipoinscripcion, null: false, foreign_key: true
      t.string :nombre
      t.text :descripcion
      t.string :foto
      t.text :normativo
      t.string :tipo
      t.date :fecha_inicio
      t.date :fecha_termino
      t.integer :cupos_maximos
      t.string :estado
      t.text :reglas

      t.timestamps
    end
  end
end
