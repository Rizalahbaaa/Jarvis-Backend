require 'dotenv/load'
class ReminderMailer < ApplicationMailer
  def my_reminder(email, note)
    @note = note
    # @url = "http://127.0.0.1:3000/api/"
    @url = ENV['ROOT_URL']

    mail(to: email, subject: 'Event Reminder')
  end
end
