require 'dotenv/load'
class ReminderMailer < ApplicationMailer
  def my_reminder(user, note)
    @note = note
    @user = user
    @url = "http://127.0.0.1:3000/api/"
    # @url = ENV['ROOT_URL']

    mail(to: "#{user.username} <#{user.email}>", subject: 'Event Reminder')
  end
end
