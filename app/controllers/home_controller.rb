class HomeController < ApplicationController
  def index

  end

  def publicos
    @campeonatos = Campeonato.includes(:club).all
  end
  
end
