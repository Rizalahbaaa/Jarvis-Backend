require 'dotenv/load'
class UserMailer < ApplicationMailer
  default from: 'no-reply@mail.com'

  def registration_confirmation(user)
    @user = user
    @url = ENV['ROOT_URL']

    mail(to: "#{user.username} <#{user.email}>", subject: 'Registration Confirmation')
  end
end
