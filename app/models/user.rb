# app/models/user.rb
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Si quieres puedes usar STI para diferenciar roles, o agregar un campo rol
  # enum rol: { jugador: 0, administrador_club: 1 }

  belongs_to :club, optional: true  # solo para administradores de club
  accepts_nested_attributes_for :club
  # Validaciones básicas y lógica extra
end

# app/models/club.rb
class Club < ApplicationRecord
  has_one :user, dependent: :destroy  # usuario administrador

  accepts_nested_attributes_for :user

  validates :nombre, :direccion, :telefono, :email, presence: true
end
