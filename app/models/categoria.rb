class Categoria < ApplicationRecord
  self.table_name = 'categorias'
  has_many :campeonato_categorias, dependent: :destroy
  has_many :campeonatos, through: :campeonato_categorias

  validates :nombre, presence: true
end
