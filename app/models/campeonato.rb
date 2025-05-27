class Campeonato < ApplicationRecord
  belongs_to :club
  belongs_to :categoria
  has_many :tipo_inscripcions, dependent: :destroy

  validates :nombre, presence: true
  validates :fecha_inicio, presence: true
  validates :fecha_termino, presence: true
  validates :estado, presence: true
  validates :cupos_maximos, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
