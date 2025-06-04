class Inscripcion < ApplicationRecord
  belongs_to :tipo_inscripcion
  belongs_to :campeonato
  belongs_to :user
  belongs_to :categoria 
  validates :estado, inclusion: { in: %w[activo inactivo] }
end
