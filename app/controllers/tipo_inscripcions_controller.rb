class TipoInscripcionsController < ApplicationController
  before_action :set_tipo_inscripcion, only: %i[show edit update destroy]
  before_action :set_campeonato

  def index
    @tipo_inscripcions = @campeonato.tipo_inscripcions
  end

  def show
  end

  def new
    @tipo_inscripcion = @campeonato.tipo_inscripcions.build
  end

  def create
    @tipo_inscripcion = @campeonato.tipo_inscripcions.build(tipo_inscripcion_params)
    if @tipo_inscripcion.save
      redirect_to campeonato_tipo_inscripcions_path(@campeonato), notice: "Tipo de inscripción creado."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tipo_inscripcion.update(tipo_inscripcion_params)
      redirect_to campeonato_tipo_inscripcions_path(@campeonato), notice: "Tipo de inscripción actualizado."
    else
      render :edit
    end
  end

  def destroy
    @tipo_inscripcion.destroy
    redirect_to campeonato_tipo_inscripcions_path(@campeonato), notice: "Tipo de inscripción eliminado."
  end

  private

  def set_campeonato
    @campeonato = Campeonato.find(params[:campeonato_id])
  end

  def set_tipo_inscripcion
    @tipo_inscripcion = TipoInscripcion.find(params[:id])
  end

  def tipo_inscripcion_params
    params.require(:tipo_inscripcion).permit(:nombre, :monto, :fecha_limite_pago, :beneficios)
  end
end
