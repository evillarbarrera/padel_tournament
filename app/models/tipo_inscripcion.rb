class TipoInscripcion < ApplicationRecord
  belongs_to :campeonato

  validates :nombre, :monto, :fecha_limite_pago, presence: true
end
