# config/initializers/solid_queue.rb

SolidQueue::Record.connects_to database: { writing: :primary } if defined?(SolidQueue::Record)

module SolidQueue
  class Job
    def priority=(_value)
      # No hace nada, simplemente ignorar
    end
  end
end