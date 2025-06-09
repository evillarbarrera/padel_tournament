class Pareja < ApplicationRecord
  belongs_to :inscripcion_1, class_name: "Inscripcion", foreign_key: :inscripcion_1_id
  belongs_to :inscripcion_2, class_name: "Inscripcion", foreign_key: :inscripcion_2_id

  validates :estado, inclusion: { in: %w[pendiente confirmados] }

  # Opcional: evita que alguien se empareje consigo mismo
  validate :no_repetir_jugador

  def no_repetir_jugador
    if inscripcion_1_id == inscripcion_2_id
      errors.add(:base, "Una pareja no puede tener dos veces la misma inscripción")
    end
  end
end
