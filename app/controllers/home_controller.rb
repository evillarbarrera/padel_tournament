class HomeController < ApplicationController
  def index

  end

  def publicos
    @campeonatos = Campeonato.includes(:club).all
    @campeonatos = @campeonatos.where(club_id: params[:club_id]) if params[:club_id].present?
    @campeonatos = @campeonatos.where(tipo: params[:tipo]) if params[:tipo].present?
  end
  
end
