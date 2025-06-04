class AddCategoriaIdToInscripcions < ActiveRecord::Migration[8.0]
  def change
    add_column :inscripcions, :categoria_id, :integer
  end
end
