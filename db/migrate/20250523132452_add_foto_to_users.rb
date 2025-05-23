class AddFotoToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :foto, :string
  end
end
