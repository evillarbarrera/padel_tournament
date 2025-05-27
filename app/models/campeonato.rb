class Campeonato < ApplicationRecord
  belongs_to :club
  belongs_to :categoria
  has_many :tipo_inscripcions, dependent: :destroy

  validates :nombre, :tipo, :fecha_inicio, :fecha_termino, :cupos_maximos, :estado, presence: true
end
