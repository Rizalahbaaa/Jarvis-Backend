require 'dotenv/load'
class UserMailer < ApplicationMailer
  default from: 'no-reply@mail.com'

  def registration_confirmation(user)
    @user = user
    @url = ENV['ROOT_URL']

    # if you want to use email for development, please uncommment @url below and comment @url above
    # @url = "http://127.0.0.1:3000/api/"

    mail(to: "#{user.username} <#{user.email}>", subject: 'Registration Confirmation')
  end

  def forgot_password(user)
    @user = user
    # @url = ENV['ROOT_URL']
    @url = "https://qatrosjarvis.netlify.app/resetpassword/"

    # if you want to use email for development, please uncommment @url below and comment @url above
    # @url = "http://127.0.0.1:3000/api/"

    mail(to: "#{user.username} <#{user.email}>", subject: 'Reset Password Instruction')
  end
end
