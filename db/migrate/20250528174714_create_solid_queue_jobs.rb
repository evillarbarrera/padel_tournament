class CreateSolidQueueJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name
      t.string :job_class
      t.text :arguments
      t.datetime :run_at
      t.datetime :locked_at
      t.datetime :failed_at
      t.timestamps
    end

    add_index :solid_queue_jobs, :queue_name
    add_index :solid_queue_jobs, :run_at
  end
end
