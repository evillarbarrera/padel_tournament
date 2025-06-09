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
  end

  def edit
    @campeonato = Campeonato.includes(:tipo_inscripcions, :categorias).find(params[:id])
    @categorias = Categoria.all.order(:nombre)
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
