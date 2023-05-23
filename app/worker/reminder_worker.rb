# require 'sidekiq'
require 'sidekiq-scheduler'

class ReminderWorker
  include Sidekiq::Worker

  def perform(user, note)
    # puts 'Hello world'
    ReminderMailer.my_reminder(user, note).deliver_later
  end
end
