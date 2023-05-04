class InvitationMailer < ApplicationMailer
    default from: 'no-reply@mail.com'

    # def invite(user, team)
    #   @user = user
    #   @team = team
    #   @invitation_token = user.invitation_token
    #   mail(to: user.email, subject: "Undangan bergabung ke dalam tim")
    # end
      def invitation_email(user_note)
        @user_note = user_note
        mail(to: @user_note.user.email, subject: 'Undangan Bergabung ke Tim')
        # format.html { render 'invitation_email.html.erb' }
      end
end