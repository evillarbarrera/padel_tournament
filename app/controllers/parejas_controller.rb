# app/controllers/parejas_controller.rb
class ParejasController < ApplicationController
  def create
    @pareja = Pareja.new(
      inscripcion_1_id: params[:inscripcion_1_id],
      inscripcion_2_id: params[:inscripcion_2_id],
      estado: "pendiente"
    )

    if @pareja.save
      redirect_to edit_user_path(current_user), notice: "¡Pareja creada exitosamente!"
    else
      redirect_to edit_user_path(current_user), alert: "Hubo un error al crear la pareja"
    end
  end
end
