class HomeController < ApplicationController
  def index

  end

  def publicos
    @campeonatos = Campeonato.all

    # Aplica filtros si están presentes
    @campeonatos = @campeonatos.where(club_id: params[:club_id]) if params[:club_id].present?
    @campeonatos = @campeonatos.where(tipo: params[:tipo]) if params[:tipo].present?

    # Paginación (5 por página)
    @campeonatos = @campeonatos.page(params[:page]).per(5)
  end
  
end
