class HorariosBloqueadosController < ApplicationController
  protect_from_forgery with: :null_session # si estás usando API

  def create
    campeonato = Campeonato.find(params[:campeonato_id])
    params[:bloqueos].each do |b|
      HorarioBloqueado.create!(
        campeonato: campeonato,
        fechahora_inicio: b[:fechahora_inicio],
        fechahora_fin: b[:fechahora_fin]
      )
    end

    render json: { status: 'ok' }
  end
end
