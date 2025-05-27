class RemoveTipoinscripcionIdFromCampeonatos < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :campeonatos, column: :tipoinscripcion_id
    remove_column :campeonatos, :tipoinscripcion_id, :integer
  end
end
