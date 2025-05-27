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

end
