class TipoInscripcion < ApplicationRecord
  belongs_to :campeonato

  validates :nombre, presence: true
  validates :monto, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :fecha_limite_pago, presence: true
end
