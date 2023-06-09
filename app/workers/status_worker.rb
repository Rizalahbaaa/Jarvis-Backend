require 'sidekiq-scheduler'

class StatusWorker
  include Sidekiq::Worker

  def perform
    UserNote.auto_change_status
  end
end
