class CreatePartidos < ActiveRecord::Migration[8.0]
  def change
    create_table :partidos do |t|
      t.integer :pareja_id_1
      t.integer :pareja_id_2
      t.date :fecha
      t.time :hora
      t.string :estado
      t.integer :cancha_id

      t.timestamps
    end
  end
end
