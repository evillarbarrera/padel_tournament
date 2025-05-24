# app/models/user.rb
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  has_one :role
  has_one :club, through: :role

  accepts_nested_attributes_for :role
end

# # app/models/club.rb
# class Club < ApplicationRecord
#   belongs_to :user
#   has_one :user, dependent: :destroy  # usuario administrador

#   accepts_nested_attributes_for :user

#   validates :nombre, :direccion, :telefono, :email, presence: true
# end
