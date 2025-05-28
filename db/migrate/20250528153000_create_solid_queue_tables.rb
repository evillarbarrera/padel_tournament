class CreateSolidQueueTables < ActiveRecord::Migration[7.1]
  def change
    create_table :solid_queue_processes do |t|
      t.string :pid
      t.string :hostname
      t.string :worker_name
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
  end
end
