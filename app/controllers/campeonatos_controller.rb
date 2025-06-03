class CampeonatosController < ApplicationController
  before_action :set_campeonato, only: [:show, :edit, :update, :destroy]

  layout "admin"

  def index
    @campeonatos = Campeonato.where(club_id: current_user.club.id)

    if params[:nombre].present?
      @campeonatos = @campeonatos.where("nombre ILIKE ?", "%#{params[:nombre]}%")
    end

    if params[:tipo].present? && params[:tipo] != 'Todos'
      @campeonatos = @campeonatos.where(tipo: params[:tipo])
    end

    if params[:estado].present? && params[:estado] != 'Todos'
      @campeonatos = @campeonatos.where(estado: params[:estado])
    end

    @campeonatos = @campeonatos.order(fecha_inicio: :asc)
  end

  def show; end

  def new
    @campeonato = Campeonato.new
    @campeonato.tipo_inscripcions.build
  end

  def edit; end

  def create
    @campeonato = Campeonato.new(campeonato_params)
    @campeonato.club_id = current_user.club.id

    if @campeonato.save
      guardar_tipos_inscripcion
      guardar_categorias_por_nombre
      redirect_to @campeonato, notice: 'Campeonato creado correctamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @campeonato.update(campeonato_params)
      actualizar_tipos_inscripcion
      actualizar_categorias_por_nombre
      redirect_to @campeonato, notice: 'Campeonato actualizado correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @campeonato.destroy!
    redirect_to campeonatos_path, status: :see_other, notice: "Campeonato eliminado correctamente."
  end

  private

  def set_campeonato
    @campeonato = Campeonato.find(params[:id])
  end

  def campeonato_params
    params.require(:campeonato).permit(
      :nombre, :tipo, :fecha_inicio, :fecha_termino,
      :cupos_maximos, :estado, :descripcion, :normativo,
      :reglas, :foto
      # cat_mas y cat_fem NO van aquí porque no son atributos directos de Campeonato
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
  def actualizar_tipos_inscripcion
    @campeonato.tipo_inscripcions.destroy_all
    guardar_tipos_inscripcion
  end

  # Guardar categorías asociadas en create (o en update, desde actualizar_categorias_por_nombre)
  def guardar_categorias_por_nombre
    # 1) Reunir todos los nombres de cat_mas y cat_fem
    nombres = Array(params[:cat_mas]) + Array(params[:cat_fem])
    # 2) Eliminar duplicados y blancos
    nombres.map!(&:to_s)
    nombres.uniq.reject!(&:blank?)

    nombres.each do |nombre_cat|
      categoria = Categoria.find_or_create_by(nombre: nombre_cat)
      @campeonato.categorias << categoria unless @campeonato.categorias.include?(categoria)
    end
  end

  # En update: borrar asociaciones previas y volver a llamar a guardar_categorias_por_nombre
  def actualizar_categorias_por_nombre
    @campeonato.categorias.clear
    guardar_categorias_por_nombre
  end
end
