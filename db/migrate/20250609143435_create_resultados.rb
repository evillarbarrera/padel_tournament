class CreateResultados < ActiveRecord::Migration[8.0]
  def change
    create_table :resultados do |t|
      t.integer :set_1_pareja_1
      t.integer :set_1_pareja_2
      t.integer :tiebreak1_pareja_1
      t.integer :tiebreak1_pareja_2
      t.integer :set_2_pareja_1
      t.integer :set_2_pareja_2
      t.integer :tiebreak2_pareja_1
      t.integer :tiebreak2_pareja_2
      t.integer :set_3_pareja_1
      t.integer :set_3_pareja_2
      t.integer :tiebreak3_pareja_1
      t.integer :tiebreak3_pareja_2
      t.text :observaciones
      t.integer :partido_id

      t.timestamps
    end
  end
end
