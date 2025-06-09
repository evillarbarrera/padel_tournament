class UsersController < ApplicationController
    before_action :authenticate_user! # Asegúrate de que el usuario esté autenticado
    before_action :set_user, only: [:show, :edit, :update]
  def show
    # @user = User.find(params[:id])
    # @club = @user.club
    # @user = User.includes(:role, :club).find(params[:id])
    @user = User.includes(inscripcions: [:campeonato, :categoria]).find(params[:id])

  end

  def edit
    @club = @user.role&.club
  end
   
  def update
    @user = User.find(params[:id])
    @club = @user.role&.club

    User.transaction do
      if @club.present?
        @club.update(club_params)
      end

      if @user.update(user_params)
        redirect_to @user, notice: "Perfil actualizado correctamente."
      else
        render :edit
      end
    end
  end

  def set_user
    @user = User.includes(role: :club).find(params[:id])
  end

  private

  def set_user
    @user = User.includes(role: :club).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nombre, :email, :telefono, :categoria)
  end

  def club_params
    params.require(:club).permit(:nombre, :direccion, :telefono, :email)
  end

end
  