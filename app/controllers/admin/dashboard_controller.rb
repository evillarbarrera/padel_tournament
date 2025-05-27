class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_club!

  layout "admin" # si tienes un layout especial, opcional

  def index
    # Aquí puedes mostrar estadísticas, botones de gestión, etc.
  end

  private

  def require_club!
    redirect_to root_path, alert: "Acceso denegado" unless current_user.club?
  end
end
