class AddSexoToCategorias < ActiveRecord::Migration[8.0]
  def change
    add_column :categorias, :sexo, :string
  end
end
