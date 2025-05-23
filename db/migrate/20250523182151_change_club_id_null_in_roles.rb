class ChangeClubIdNullInRoles < ActiveRecord::Migration[8.0]
  def change
    change_column_null :roles, :club_id, true
  end
end
