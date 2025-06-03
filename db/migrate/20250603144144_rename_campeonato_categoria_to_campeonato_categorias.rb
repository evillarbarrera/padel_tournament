class RenameCampeonatoCategoriaToCampeonatoCategorias < ActiveRecord::Migration[7.0]
  def change
    rename_table :campeonato_categoria, :campeonato_categorias
  end
end
