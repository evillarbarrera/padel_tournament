class ParejasController < ApplicationController
  def create
    # Asegúrate que los parámetros vienen como enteros
    inscripcion_1_id = params[:inscripcion_1_id].to_i
    inscripcion_2_id = params[:inscripcion_2_id].to_i

    # Opcional: Verificar que no sea la misma inscripcion (no puedes emparejar contigo mismo)
    if inscripcion_1_id == inscripcion_2_id
      redirect_to edit_user_path(current_user), alert: "No puedes seleccionar la misma inscripción como pareja."
      return
    end

    @pareja = Pareja.new(
      inscripcion_1_id: inscripcion_1_id,
      inscripcion_2_id: inscripcion_2_id,
      estado: "pendiente"
    )

    if @pareja.save
      redirect_to edit_user_path(current_user), notice: "¡Pareja creada exitosamente!"
    else
      redirect_to edit_user_path(current_user), alert: "Hubo un error al crear la pareja: #{@pareja.errors.full_messages.join(', ')}"
    end
  end
end
