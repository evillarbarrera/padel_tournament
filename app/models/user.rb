# app/models/user.rb
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  has_one :role
  has_one :club, through: :role

  accepts_nested_attributes_for :role

  def club?
    role&.nombre == "club" || role&.nombre == "administrador"
  end

  def user_params
  params.require(:user).permit(
    :nombre, :email, :telefono, :categoria, :password, :password_confirmation,
    role_attributes: [:nombre, club_attributes: [:nombre, :direccion, :telefono, :email]]
  )
end

end
