class CreateCampeonatoCategoria < ActiveRecord::Migration[8.0]
  def change
    create_table :campeonato_categorias do |t|
      t.references :campeonato, null: false, foreign_key: true
      t.references :categoria, null: false, foreign_key: true

      t.timestamps
    end
  end
end
