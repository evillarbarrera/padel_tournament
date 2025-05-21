class UsersController < ApplicationController
    before_action :authenticate_user! # Asegúrate de que el usuario esté autenticado

    def show
      @user = User.find(params[:id])
    end


    
    
    private
  
    def user_params
      params.require(:user).permit(:nombre, :email, :telefono, :categoria)
    end

  end
  