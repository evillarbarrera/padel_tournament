class CampeonatosController < ApplicationController
  before_action :set_campeonato, only: [:show, :edit, :update, :destroy]

  layout "admin"

  def index
    @campeonatos = Campeonato.all
    @campeonatos = @campeonatos.order(fecha_inicio: :asc)

    if params[:nombre].present?
      @campeonatos = @campeonatos.where("nombre ILIKE ?", "%#{params[:nombre]}%")
    end

    if params[:tipo].present? && params[:tipo] != 'Todos'
      @campeonatos = @campeonatos.where(tipo: params[:tipo])
    end

    if params[:estado].present? && params[:estado] != 'Todos'
      @campeonatos = @campeonatos.where(estado: params[:estado])
    end

    
  end

  def show; end

  def new
    @campeonato = Campeonato.new
    @campeonato.tipo_inscripcions.build

    @categorias = Categoria.all.order(:nombre)
    @parejas = Pareja.all
    @canchas = Cancha.all
  end

  def edit
    @campeonato = Campeonato.includes(:tipo_inscripcions, :categorias).find(params[:id])
    @categorias = Categoria.all.order(:nombre)
    @parejas = Pareja.all
    @canchas = Cancha.all
  end

  def create
    @campeonato = Campeonato.new(campeonato_params)
    @campeonato.club_id = current_user.club.id

    if @campeonato.save
      guardar_tipos_inscripcion

      redirect_to @campeonato, notice: 'Campeonato creado correctamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @campeonato = Campeonato.find(params[:id])

      if @campeonato.update(campeonato_params)
        actualizar_tipos_inscripcion(@campeonato)
        redirect_to @campeonato, notice: 'Campeonato actualizado correctamente.'
      else
        render :edit
      end
  end

  def destroy
    if @campeonato.destroy
      redirect_to campeonatos_path, status: :see_other, notice: "Campeonato eliminado correctamente."
    else
      redirect_to campeonatos_path, alert: "No se pudo eliminar el campeonato."
    end
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to campeonatos_path, alert: "Error: el campeonato tiene registros asociados."
  end

  def guardar_bloqueos
    campeonato = Campeonato.find(params[:id])
    bloqueos = params[:bloqueos]
    fecha_inicio = Date.parse(params[:fecha_inicio])
    fecha_termino = Date.parse(params[:fecha_termino])

    bloqueos.each do |bloqueo|
      dia = bloqueo[:dia]
      hora = bloqueo[:hora].to_i

      # Convertir nombre de día a número (lunes = 1, domingo = 7)
      dia_num = {
        "Lunes" => 1, "Martes" => 2, "Miércoles" => 3,
        "Jueves" => 4, "Viernes" => 5, "Sábado" => 6, "Domingo" => 7
      }[dia]

      # Generar todas las fechas entre fecha_inicio y fecha_termino con ese día
      (fecha_inicio..fecha_termino).each do |fecha|
        if fecha.cwday == dia_num
          fechahora_inicio = fecha.to_datetime.change({ hour: hora, min: 0 })
          fechahora_fin = fechahora_inicio + 1.hour

          HorarioBloqueado.create!(
            campeonato_id: campeonato.id,
            fechahora_inicio: fechahora_inicio,
            fechahora_fin: fechahora_fin
          )
        end
      end
    end

    render json: { success: true }
  end

  def bloqueos
    campeonato = Campeonato.find(params[:id])
    bloqueos = campeonato.horario_bloqueados

    render json: bloqueos.map { |b| {
      id: b.id,
      fechahora_inicio: b.fechahora_inicio,
      fechahora_fin: b.fechahora_fin
    } }
  end

  require 'ostruct'  # asegúrate que esté arriba del archivo
  def generar_fixture
    begin
      fecha_inicio = Date.parse(params[:fecha_inicio])
      fecha_fin = Date.parse(params[:fecha_fin])
      duracion = params[:duracion].to_i
      campeonato_id = params[:campeonato_id].to_i
      canchas_ids = params[:canchas].map(&:to_i) rescue []

      parejas = Pareja
                  .where(estado: 'pendiente')
                  .includes(inscripcion_1: :user, inscripcion_2: :user)
                  .map do |p|
                    OpenStruct.new(
                      id: p.id,
                      nombre: "#{p.inscripcion_1.user.nombre} / #{p.inscripcion_2.user.nombre}"
                    )
                  end

      if canchas_ids.blank? || parejas.size < 4
        return render json: { error: 'Se requieren al menos cuatro parejas y una cancha' }, status: :unprocessable_entity
      end

      # Completar parejas para múltiplos de 4 (mínimo 4 parejas por grupo)
      total_parejas = (parejas.size.to_f / 4).ceil * 4
      (total_parejas - parejas.size).times do |i|
        parejas << OpenStruct.new(id: nil, nombre: "Pareja faltante #{i + 1}")
      end

      # Agrupar parejas en grupos de 4
      grupos = parejas.shuffle.each_slice(4).to_a

      partidos = []

      # Partidos de todos contra todos en cada grupo
      grupos.each_with_index do |grupo, i|
        grupo.combination(2).each do |p1, p2|
          partidos << {
            fase: 'grupo',
            grupo: "Grupo #{('A'.ord + i).chr}",
            pareja_1: p1,
            pareja_2: p2
          }
        end
      end

      # Clasifican 2 mejores de cada grupo, generan octavos
      # Número de grupos
      n_grupos = grupos.size
      clasificados_por_grupo = 2
      total_clasificados = n_grupos * clasificados_por_grupo

      # Rellenar para octavos (16 equipos) si hace falta
      total_octavos = 16
      if total_clasificados < total_octavos
        faltantes = total_octavos - total_clasificados
        faltantes.times do |i|
          partidos << {
            fase: 'grupo',
            grupo: nil,
            pareja_1: OpenStruct.new(id: nil, nombre: "Clasificado faltante #{i + 1}"),
            pareja_2: OpenStruct.new(id: nil, nombre: "Bye")
          }
        end
      end

      # Octavos de final (8 partidos, 16 parejas)
      (0...8).each do |i|
        partidos << {
          fase: 'octavos',
          grupo: nil,
          pareja_1: OpenStruct.new(id: nil, nombre: "Ganador Grupo #{('A'.ord + (i * 2) / 2).chr}"),
          pareja_2: OpenStruct.new(id: nil, nombre: "Segundo Grupo #{('A'.ord + (i * 2 + 1) / 2).chr}")
        }
      end

      # Cuartos de final (4 partidos)
      4.times do |i|
        partidos << {
          fase: 'cuartos',
          grupo: nil,
          pareja_1: OpenStruct.new(id: nil, nombre: "Ganador Octavos #{i * 2 + 1}"),
          pareja_2: OpenStruct.new(id: nil, nombre: "Ganador Octavos #{i * 2 + 2}")
        }
      end

      # Semifinales (2 partidos)
      2.times do |i|
        partidos << {
          fase: 'semifinal',
          grupo: nil,
          pareja_1: OpenStruct.new(id: nil, nombre: "Ganador Cuartos #{i * 2 + 1}"),
          pareja_2: OpenStruct.new(id: nil, nombre: "Ganador Cuartos #{i * 2 + 2}")
        }
      end

      # Final (1 partido)
      partidos << {
        fase: 'final',
        grupo: nil,
        pareja_1: OpenStruct.new(id: nil, nombre: "Ganador Semi 1"),
        pareja_2: OpenStruct.new(id: nil, nombre: "Ganador Semi 2")
      }

      # Bloqueos y asignación de horarios
      bloques_bloqueados = HorarioBloqueado.where(campeonato_id: campeonato_id)
      current_time = fecha_inicio.to_datetime.change(hour: 9, min: 0)
      tiempo_por_cancha = Hash.new(current_time)
      partidos_agendados = []

      partidos.each do |partido|
        asignado = false
        intentos = 0

        while !asignado && intentos < 1000
          canchas_ids.each do |cancha_id|
            t_actual = tiempo_por_cancha[cancha_id]
            inicio = t_actual
            fin = inicio + duracion.minutes

            bloqueado = bloques_bloqueados.any? do |bloque|
              inicio < bloque.fechahora_fin && fin > bloque.fechahora_inicio
            end

            ocupado = partidos_agendados.any? do |p|
              p[:cancha_id] == cancha_id && inicio < p[:fecha_hora] + duracion.minutes && fin > p[:fecha_hora]
            end

            unless bloqueado || ocupado
              partidos_agendados << {
                pareja_1: { id: partido[:pareja_1].id, nombre: partido[:pareja_1].nombre },
                pareja_2: { id: partido[:pareja_2].id, nombre: partido[:pareja_2].nombre },
                cancha_id: cancha_id,
                fecha_hora: inicio,
                fase: partido[:fase],
                grupo: partido[:grupo]
              }
              tiempo_por_cancha[cancha_id] += duracion.minutes
              asignado = true
              break
            end
          end

          unless asignado
            current_time += duracion.minutes
            if current_time.hour >= 21
              current_time = current_time.beginning_of_day + 1.day + 9.hours
            end
            if current_time > fecha_fin.to_datetime.change(hour: 21, min: 0)
              return render json: { error: 'No hay más espacio disponible dentro del rango de fechas.' }, status: :unprocessable_entity
            end
            intentos += 1
          end
        end

        return render json: { error: 'No se pudo asignar un horario libre para un partido.' }, status: :unprocessable_entity unless asignado
      end

      render json: {
        partidos: partidos_agendados,
        bloqueos: bloques_bloqueados.map { |b| { fechahora_inicio: b.fechahora_inicio, fechahora_fin: b.fechahora_fin } }
      }
    rescue => e
      render json: { error: e.message, backtrace: e.backtrace[0..5] }, status: 500
    end
  end











  private

  def set_campeonato

    @campeonato = Campeonato.includes(inscripciones: [:user, :categoria]).find(params[:id])


  end

def campeonato_params
  params.require(:campeonato).permit(
    :nombre, :tipo, :fecha_inicio, :fecha_termino,
    :cupos_maximos, :estado, :descripcion, :normativo,
    :reglas, :foto,
    categoria_ids: [],
    tipo_inscripcions_attributes: [:id, :nombre, :monto, :fecha_limite_pago, :beneficios, :_destroy]
  )
end

  # Guardar tipos inscripción nuevos en create
  def guardar_tipos_inscripcion
    return unless params[:tipo_nombre].present?

    params[:tipo_nombre].each_with_index do |nombre, i|
      next if nombre.blank?

      @campeonato.tipo_inscripcions.create(
        nombre: nombre,
        monto: params[:tipo_monto][i],
        fecha_limite_pago: params[:tipo_fecha_limite][i],
        beneficios: params[:tipo_beneficios][i]
      )
    end
  end

    # Actualizar tipos inscripción en update
    def actualizar_tipos_inscripcion(cam)
      puts ">>> actualizando tipos inscripción"

      nombres = params[:tipo_nombre] || []
      montos = params[:tipo_monto] || []
      fechas = params[:tipo_fecha_limite] || []
      beneficios = params[:tipo_beneficios] || []
      ids = params[:tipo_id] || []

      # 1. Eliminar los que ya no vienen en el form
      ids_param = ids.map(&:to_i)
      ids_existentes = cam.tipo_inscripcions.pluck(:id)
      ids_a_eliminar = ids_existentes - ids_param

      cam.tipo_inscripcions.where(id: ids_a_eliminar).destroy_all

      # 2. Actualizar los existentes
      ids.each_with_index do |id, index|
        tipo = cam.tipo_inscripcions.find_by(id: id)

        if tipo
          tipo.update(
            nombre: nombres[index],
            monto: montos[index],
            fecha_limite_pago: fechas[index],
            beneficios: beneficios[index]
          )
        end
      end

      # 3. Crear nuevos que no tienen ID
      if nombres.length > ids.length
        (ids.length...nombres.length).each do |index|
          cam.tipo_inscripcions.create(
            nombre: nombres[index],
            monto: montos[index],
            fecha_limite_pago: fechas[index],
            beneficios: beneficios[index]
          )
        end
      end
    end




end
