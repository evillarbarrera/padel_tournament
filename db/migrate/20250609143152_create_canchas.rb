class CreateCanchas < ActiveRecord::Migration[8.0]
  def change
    create_table :canchas do |t|
      t.string :nombre
      t.integer :numero
      t.integer :club_id

      t.timestamps
    end
  end
end
