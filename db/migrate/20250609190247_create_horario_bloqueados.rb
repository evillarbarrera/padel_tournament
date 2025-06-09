class CreateHorarioBloqueados < ActiveRecord::Migration[8.0]
  def change
    create_table :horario_bloqueados do |t|
      t.references :campeonato, null: false, foreign_key: true
      t.datetime :fechahora_inicio
      t.datetime :fechahora_fin

      t.timestamps
    end
  end
end
