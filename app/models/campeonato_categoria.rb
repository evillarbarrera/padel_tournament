class CampeonatoCategoria < ApplicationRecord
  self.table_name = "campeonato_categorias"
  belongs_to :campeonato
  belongs_to :categoria
end
