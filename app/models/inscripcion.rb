class Inscripcion < ApplicationRecord

  belongs_to :tipo_inscripcion
  belongs_to :campeonato
  belongs_to :user
  belongs_to :categoria 
  validates :estado, inclusion: { in: %w[activo inactivo] }

  has_many :parejas_como_1, class_name: "Pareja", foreign_key: :inscripcion_1_id
  has_many :parejas_como_2, class_name: "Pareja", foreign_key: :inscripcion_2_id

  # Si quieres acceso a todas las parejas (como jugador 1 o 2):
  def parejas
    Pareja.where("inscripcion_1_id = ? OR inscripcion_2_id = ?", id, id)
  end
end
