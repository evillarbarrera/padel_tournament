class Campeonato < ApplicationRecord
  belongs_to :club
  
  has_many :campeonato_categorias, dependent: :destroy
  has_many :categorias, through: :campeonato_categorias

  has_many :tipo_inscripcions, dependent: :destroy
  accepts_nested_attributes_for :tipo_inscripcions, allow_destroy: true 

  validates :nombre, presence: true
  validates :fecha_inicio, presence: true
  validates :fecha_termino, presence: true
  validates :estado, presence: true
  validates :cupos_maximos, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
