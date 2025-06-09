class RenameCampeonatoCategoriaToCampeonatoCategorias < ActiveRecord::Migration[7.0]
  def up
    rename_table :campeonato_categoria, :campeonato_categorias if table_exists?(:campeonato_categoria)
  end

  def down
    rename_table :campeonato_categorias, :campeonato_categoria if table_exists?(:campeonato_categorias)
  end
end
