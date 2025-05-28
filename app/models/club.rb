class Club < ApplicationRecord
  has_many :roles
  has_many :users, through: :roles
  has_one_attached :logo
  validates :nombre, :direccion, :telefono, :email, presence: true
end
