class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.string :nombre
      t.string :direccion
      t.string :telefono
      t.string :email
      t.string :logo
      t.datetime :fecha_creacion

      t.timestamps
    end
  end
end
