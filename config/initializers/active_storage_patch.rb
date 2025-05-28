# config/initializers/active_storage_patch.rb
Rails.application.config.to_prepare do
  module ActiveStorage
    class Attachment
      def purge_later
        ActiveStorage::PurgeJob.perform_later(self)
      end
    end
  end
end
