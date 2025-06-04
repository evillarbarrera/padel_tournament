class InscripcionesController < ApplicationController
  before_action :authenticate_user!


    def new
    @inscripcion = Inscripcion.new
    if params[:campeonato_id].present?
         @campeonatos = Campeonato.all
        @tipos_inscripcion = TipoInscripcion.all
        @categorias = Categoria.all  # <--- Aquí defines @categorias
        @campeonato = Campeonato.first # o la lógica para asignar @campeonato
    else
        @categorias = Categoria.all
        @tipos_inscripcion = TipoInscripcion.all
    end
    end

    def show
        @inscripcion = Inscripcion.find(params[:id])
    end

    def create
        @inscripcion = Inscripcion.new(inscripcion_params)
        @inscripcion.user = current_user
        @campeonato = Campeonato.find_by(id: @inscripcion.campeonato_id)
        @categorias = Categoria.all  # <--- También aquí, si vuelves a renderizar :new
        @campeonatos = Campeonato.all
        @tipos_inscripcion = TipoInscripcion.all

        
        if Inscripcion.exists?(user_id: current_user.id, campeonato_id: @inscripcion.campeonato_id, categoria_id: @inscripcion.categoria_id)
            @campeonatos = Campeonato.all
            @tipos_inscripcion = TipoInscripcion.all
            @categorias = Categoria.all
            @error_modal = true
            render :new
        elsif @inscripcion.save
            redirect_to inscripcione_path(@inscripcion), notice: "Inscripción creada con éxito."
        else
            @campeonatos = Campeonato.all
            @tipos_inscripcion = TipoInscripcion.all
            @categorias = Categoria.all
            render :new
        end

    end   

  private

    def inscripcion_params
    params.require(:inscripcion).permit(:campeonato_id, :tipo_inscripcion_id, :categoria_id)
    end


end
