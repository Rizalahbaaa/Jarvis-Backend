require 'sidekiq-scheduler'

class StatusWorker
  include Sidekiq::Worker

  def perform
    UserNote.auto_late
  end
end
