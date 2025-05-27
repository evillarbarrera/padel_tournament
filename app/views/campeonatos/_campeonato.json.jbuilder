json.extract! campeonato, :id, :club_id, :categoria_id, :tipoinscripcion_id, :nombre, :descripcion, :foto, :normativo, :tipo, :fecha_inicio, :fecha_termino, :cupos_maximos, :estado, :reglas, :created_at, :updated_at
json.url campeonato_url(campeonato, format: :json)
