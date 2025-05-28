class AddMissingColumnsToSolidQueueJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :solid_queue_jobs, :active_job_id, :string
    add_column :solid_queue_jobs, :priority, :integer, default: 0
  end
end