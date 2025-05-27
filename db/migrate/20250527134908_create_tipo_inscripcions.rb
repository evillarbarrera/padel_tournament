class CreateTipoInscripcions < ActiveRecord::Migration[8.0]
  def change
    create_table :tipo_inscripcions do |t|
      t.string :nombre
      t.integer :monto
      t.date :fecha_limite_pago
      t.text :beneficios
      t.references :campeonato, null: false, foreign_key: true

      t.timestamps
    end
  end
end
