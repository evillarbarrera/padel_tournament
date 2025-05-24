class Club < ApplicationRecord
  has_many :roles
  has_many :users, through: :roles

  validates :nombre, :direccion, :telefono, :email, presence: true
end
