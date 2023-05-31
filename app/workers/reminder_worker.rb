require 'sidekiq-scheduler'

class ReminderWorker
  include Sidekiq::Worker

  def perform
    Note.send_reminder
  end
end
