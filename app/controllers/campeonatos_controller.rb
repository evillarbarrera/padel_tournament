class CampeonatosController < ApplicationController
  before_action :set_campeonato, only: %i[ show edit update destroy ]

  layout "admin" # si tienes un layout especial, opcional
  # GET /campeonatos or /campeonatos.json
  def index
    @campeonatos = Campeonato.all
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

    respond_to do |format|
      if @campeonato.save
        format.html { redirect_to @campeonato, notice: "Campeonato was successfully created." }
        format.json { render :show, status: :created, location: @campeonato }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @campeonato.errors, status: :unprocessable_entity }
      end
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
      @campeonato = Campeonato.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def campeonato_params
      params.require(:campeonato).permit(
        :club_id, :categoria_id, :nombre, :descripcion, :foto, :normativo, :tipo,
        :fecha_inicio, :fecha_termino, :cupos_maximos, :estado, :reglas,
        tipo_inscripcions_attributes: [:id, :nombre, :monto, :fecha_limite_pago, :beneficios, :_destroy]
      )
    end
end
