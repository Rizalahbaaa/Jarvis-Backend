require 'dotenv/load'
class UserMailer < ApplicationMailer
  default from: 'no-reply@mail.com'

  def registration_confirmation(user)
    @user = user
    # @url = ENV['ROOT_URL']
    @url = "http://127.0.0.1:3000/api"

    mail(to: "#{user.username} <#{user.email}>", subject: 'Registration Confirmation')
  end
end
