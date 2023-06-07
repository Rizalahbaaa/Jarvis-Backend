require 'sidekiq-scheduler'

class RepeaterWorker
  include Sidekiq::Worker

  def perform
    Note.send_repeater
  end
end
