require 'dotenv/load'
class ReminderMailer < ApplicationMailer
  def my_reminder(email, note)
    @note = note

    mail(to: email, subject: 'Event Reminder')
  end
end
