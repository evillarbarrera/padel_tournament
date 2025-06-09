class Cancha < ApplicationRecord
    belongs_to :club
    has_many :partidos
end
