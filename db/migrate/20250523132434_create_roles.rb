class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.references :club, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :nombre
      t.string :estado
      t.datetime :fecha_creacion

      t.timestamps
    end
  end
end
