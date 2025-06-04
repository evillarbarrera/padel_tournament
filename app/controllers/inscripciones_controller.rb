class InscripcionesController < ApplicationController
  before_action :authenticate_user!


    def new
    @inscripcion = Inscripcion.new
    if params[:campeonato_id].present?
        @campeonato = Campeonato.find(params[:campeonato_id])
        @categorias = @campeonato.categorias
        @tipos_inscripcion = @campeonato.tipo_inscripcions
    else
        @categorias = Categoria.all
        @tipos_inscripcion = TipoInscripcion.all
    end
    end



  def create
    @inscripcion = Inscripcion.new(inscripcion_params)
    @inscripcion.user = current_user

    if @inscripcion.save
      redirect_to root_path, notice: "Inscripción creada con éxito."
    else
      @campeonatos = Campeonato.all
      @tipos_inscripcion = TipoInscripcion.all
      render :new
    end
  end

  private

    def inscripcion_params
    params.require(:inscripcion).permit(:campeonato_id, :tipo_inscripcion_id, :categoria_id)
    end


end
