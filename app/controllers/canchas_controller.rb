class CanchasController < ApplicationController
    layout "admin"

before_action :set_cancha, only: %i[show edit update destroy]

  # Asumiendo que tienes un método que te da el club actual:
  # Puede ser current_club, o current_user.club, etc.
  def index
    @canchas = current_user.club.canchas
  end

  def show
    # Ya está seteado por set_cancha
  end

  def new
    @cancha = current_user.club.canchas.build
  end

    def create
    @cancha = current_user.club.canchas.build(cancha_params)
    if @cancha.save
        redirect_to @cancha, notice: "Cancha creada correctamente."
    else
        render :new, status: :unprocessable_entity
    end
    end


  def edit
  end

    def update
    @cancha = current_user.club.canchas.find(params[:id])
    if @cancha.update(cancha_params)
        redirect_to @cancha, notice: "Cancha actualizada correctamente."
    else
        render :edit, status: :unprocessable_entity
    end
    end


    def destroy
    @cancha = current_user.club.canchas.find(params[:id])
    @cancha.destroy
    redirect_to canchas_path, notice: "Cancha eliminada correctamente."
    end


  private

  def set_cancha
    @cancha = current_user.club.canchas.find(params[:id])
  end

  def cancha_params
    params.require(:cancha).permit(:nombre, :numero)
    # No incluimos club_id porque se asigna automáticamente
  end
end
