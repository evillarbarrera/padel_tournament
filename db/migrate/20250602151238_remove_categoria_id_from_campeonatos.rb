class RemoveCategoriaIdFromCampeonatos < ActiveRecord::Migration[8.0]
  def change
    remove_reference :campeonatos, :categoria, null: false, foreign_key: true
  end
end
