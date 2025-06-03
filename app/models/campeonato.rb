class Campeonato < ApplicationRecord
  belongs_to :club
  has_one_attached :foto

  # Asociación correcta con tabla intermedia y modelo
  has_many :campeonato_categorias, dependent: :destroy
  has_many :categorias, through: :campeonato_categorias
  accepts_nested_attributes_for :campeonato_categorias, allow_destroy: true
  # Asociación correcta para tipos de inscripción
  has_many :tipo_inscripcions, dependent: :destroy
  accepts_nested_attributes_for :tipo_inscripcions, allow_destroy: true

  # Validaciones
  validates :nombre, presence: true
  validates :fecha_inicio, presence: true
  validates :fecha_termino, presence: true
  validates :estado, presence: true
  validates :cupos_maximos, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
