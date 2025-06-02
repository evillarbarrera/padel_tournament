class CampeonatosController < ApplicationController
  before_action :set_campeonato, only: [:show, :edit, :update, :destroy]

  layout "admin" # si tienes un layout especial, opcional
  # GET /campeonatos or /campeonatos.json
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
  # GET /campeonatos/1 or /campeonatos/1.json
  def show
  end

  # GET /campeonatos/new
  def new
    @campeonato = Campeonato.new
    @campeonato.tipo_inscripcions.build  # Para que aparezca al menos uno por defecto
  end

  # GET /campeonatos/1/edit
  def edit
  end

  # POST /campeonatos or /campeonatos.json
  def create
    @campeonato = Campeonato.new(campeonato_params)
    @campeonato.club_id = current_user.club.id # Asignamos el club actual

    if @campeonato.save
      guardar_tipos_inscripcion
      guardar_categorias

      redirect_to @campeonato, notice: 'Campeonato creado correctamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /campeonatos/1 or /campeonatos/1.json
  def update
    respond_to do |format|
      if @campeonato.update(campeonato_params)
        format.html { redirect_to @campeonato, notice: "Campeonato was successfully updated." }
        format.json { render :show, status: :ok, location: @campeonato }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @campeonato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campeonatos/1 or /campeonatos/1.json
  def destroy
    @campeonato.destroy!

    respond_to do |format|
      format.html { redirect_to campeonatos_path, status: :see_other, notice: "Campeonato was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campeonato
      @campeonato = Campeonato.find(params[:id])
    end

    # Only allow a list of trusted parameters through.

  def campeonato_params
    params.require(:campeonato).permit(
      :nombre, :tipo, :fecha_inicio, :fecha_termino,
      :cupos_maximos, :estado, :descripcion, :normativo, :reglas
    )
  end

  def guardar_tipos_inscripcion
    return unless params[:tipo_nombre]

    params[:tipo_nombre].each_with_index do |nombre, i|
      @campeonato.tipo_inscripcions.create(
        nombre: nombre,
        monto: params[:tipo_monto][i],
        fecha_limite_pago: params[:tipo_fecha_limite][i],
        beneficios: params[:tipo_beneficios][i]
      )
    end
  end

  def guardar_categorias
    categorias = []

    categorias.each do |cat|
      @campeonato.categorias.create(
        nombre: cat[:nombre]
      )
    end
  end
end
