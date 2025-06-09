class Categoria < ApplicationRecord
  self.table_name = 'categorias'
  has_many :campeonato_categorias, dependent: :destroy
  has_many :campeonatos, through: :campeonato_categorias
  has_many :inscripcions
  validates :nombre, presence: true
end
