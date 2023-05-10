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

  def invitation_email(email, invite_token)
    @url = ENV['ROOT_URL']
    # @url = "http://127.0.0.1:3000/api/"

    @invite_token = invite_token
    mail(to: email, subject: 'Undangan Bergabung ke Catatan')
    # format.html { render 'invitation_email.html.erb' }
  end
end
