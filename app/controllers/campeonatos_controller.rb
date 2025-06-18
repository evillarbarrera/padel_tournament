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

      if canchas_ids.blank? || parejas.size < 1
        return render json: { error: 'Se requieren al menos dos parejas y una cancha' }, status: :unprocessable_entity
      end

      total_parejas_necesarias = params[:cupo_max].to_i > 0 ? params[:cupo_max].to_i : 8
      faltantes = total_parejas_necesarias - parejas.size

      if faltantes > 0
        faltantes.times do |i|
          parejas << OpenStruct.new(id: nil, nombre: "Pareja faltante #{i + 1}")
        end
      end

      bloques_bloqueados = HorarioBloqueado.where(campeonato_id: campeonato_id)
      partidos = []
      emparejamientos = parejas.combination(2).to_a.shuffle
      current_time = fecha_inicio.to_datetime.change(hour: 9, min: 0)
      tiempo_por_cancha = Hash.new(current_time)

      emparejamientos.each do |par|
        partido_asignado = false
        intentos = 0
        max_intentos = 1000

        while !partido_asignado && intentos < max_intentos
          canchas_ids.each do |cancha_id|
            tiempo_actual = tiempo_por_cancha[cancha_id]
            partido_inicio = tiempo_actual
            partido_fin = tiempo_actual + duracion.minutes

            bloqueado = bloques_bloqueados.any? do |bloque|
              (partido_inicio < bloque.fechahora_fin) &&
              (partido_fin > bloque.fechahora_inicio)
            end

            ocupado = partidos.any? do |p|
              p[:cancha_id] == cancha_id &&
              (partido_inicio < p[:fecha_hora] + duracion.minutes) &&
              (partido_fin > p[:fecha_hora])
            end

            unless bloqueado || ocupado
              partidos << {
                pareja_1: { id: par[0].id, nombre: par[0].nombre },
                pareja_2: { id: par[1].id, nombre: par[1].nombre },
                cancha_id: cancha_id,
                fecha_hora: partido_inicio
              }
              tiempo_por_cancha[cancha_id] += duracion.minutes
              partido_asignado = true
              break
            end
          end

          unless partido_asignado
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

        unless partido_asignado
          return render json: { error: 'No se pudo asignar un horario libre para un partido.' }, status: :unprocessable_entity
        end
      end

      render json: {
        partidos: partidos,
        bloqueos: bloques_bloqueados.map { |b| {
          fechahora_inicio: b.fechahora_inicio,
          fechahora_fin: b.fechahora_fin
        }}
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
