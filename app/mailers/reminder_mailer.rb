require 'dotenv/load'
class ReminderMailer < ApplicationMailer
  def my_reminder(email, note)
    @note = note

    mail(to: email, subject: 'Event Reminder')
  end

  def my_repeater(email, note)
    @note = note
    mail(to: email, subject: "#{@note.frequency} reminder")
  end
end
