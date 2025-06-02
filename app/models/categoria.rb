class Categoria < ApplicationRecord
  has_many :campeonato_categorias, dependent: :destroy
  has_many :campeonatos, through: :campeonato_categorias
end
