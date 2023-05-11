class InvitationMailer < ApplicationMailer
  default from: 'no-reply@mail.com'

  # def invite(user, team)
  #   @user = user
  #   @team = team
  #   @invitation_token = user.invitation_token
  #   mail(to: user.email, subject: "Undangan bergabung ke dalam tim")
  # end
  # def invitation_email(user_note)
  #   @user_note = user_note
  #   mail(to: @user_note.user.email, subject: 'Undangan Bergabung ke Catatan')
  #   # format.html { render 'invitation_email.html.erb' }
  # end

  def collab_invitation(email, invite_token)
    # @url = ENV['ROOT_URL']
    # if you want to use email for development, please uncommment @url below and comment @url above
    @url = "http://127.0.0.1:3000/api"

    @invite_token = invite_token
    mail(to: email, subject: 'Undangan Bergabung ke Catatan')
    # format.html { render 'invitation_email.html.erb' }
  end

  def team_invitation(email, invite_token)
    # @url = ENV['ROOT_URL']
    # if you want to use email for development, please uncommment @url below and comment @url above
    @url = "http://127.0.0.1:3000/api"

    @invite_token = invite_token
    mail(to: email, subject: 'Undangan Bergabung ke Tim')
    # format.html { render 'invitation_email.html.erb' }
  end
end
