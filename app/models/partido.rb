class Partido < ApplicationRecord
  belongs_to :cancha, optional: true
  has_one :resultado
end