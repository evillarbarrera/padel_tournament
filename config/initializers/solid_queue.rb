# config/initializers/solid_queue.rb

SolidQueue::Record.connects_to database: { writing: :primary } if defined?(SolidQueue::Record)
