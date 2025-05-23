class Users::RegistrationsController < Devise::RegistrationsController
  before_action :require_no_authentication, only: [:create]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    tipo = params[:tipo_usuario]

    unless %w[jugador club].include?(tipo)
      render json: { error: 'Tipo de usuario inválido' }, status: :unprocessable_entity and return
    end

    build_resource(sign_up_params)

    ActiveRecord::Base.transaction do
      if resource.save
        if tipo == 'club'
          club = Club.create!(
            nombre: club_params[:club_nombre],
            direccion: club_params[:club_direccion],
            telefono: club_params[:club_telefono],
            email: club_params[:club_email]
          )
          club.logo.attach(club_params[:club_logo]) if club_params[:club_logo]

          Role.create!(
            user: resource,
            club: club,
            nombre: "administrador",
            estado: "activo"
          )
        else
          Role.create!(
            user: resource,
            nombre: "jugador",
            estado: "activo"
          )
        end

        resource.foto.attach(sign_up_params[:foto]) if sign_up_params[:foto]

      else
        # Si falla guardar usuario, lanza excepción para rollback
        raise ActiveRecord::Rollback
      end
    end

    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Error al registrar: #{e.record.errors.full_messages.join(', ')}"
    clean_up_passwords resource
    render :new, status: :unprocessable_entity
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nombre, :telefono, :categoria, :foto)
  end

  def club_params
    params.permit(:club_nombre, :club_direccion, :club_telefono, :club_email, :club_logo)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :nombre, :email, :telefono, :categoria, :foto,
      :tipo_usuario,
      :club_nombre, :club_direccion, :club_telefono, :club_email, :club_logo
    ])
  end
end
