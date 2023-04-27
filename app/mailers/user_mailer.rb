require 'dotenv/load'
class UserMailer < ApplicationMailer
  default from: 'no-reply@mail.com'

  def registration_confirmation(user)
    @user = user
    @url = 'https://bantuin.fly.dev/api/'

    mail(to: "#{user.username} <#{user.email}>", subject: 'Registration Confirmation')
  end
end
