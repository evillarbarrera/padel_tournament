class RemoveTipoinscripcionIdFromCampeonatos < ActiveRecord::Migration[8.0]
  def change
    remove_column :campeonatos, :tipoinscripcion_id, :integer
  end
end
