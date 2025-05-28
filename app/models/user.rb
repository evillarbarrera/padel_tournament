# app/models/user.rb
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  has_one :role
  has_one :club, through: :role
  has_one_attached :foto
  accepts_nested_attributes_for :role

  def club?
    role&.nombre == "club" || role&.nombre == "administrador"
  end

  # Deshabilitar purga automática
  after_save :skip_auto_purge_foto

  private

  def skip_auto_purge_foto
    # Esto evita que se intente purgar el archivo anterior automáticamente
    foto.attachment&.purge_later if foto.attached? && foto.attachment.blob.attachments.many?
  end

end
