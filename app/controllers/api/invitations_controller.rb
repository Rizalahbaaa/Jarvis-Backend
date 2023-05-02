class Api::InvitationsController < ApplicationController
    def create
        @invitation = Invitation.new(invitation_params)
        
        # Generate invite token
        @invitation.invitation_token = SecureRandom.hex(20)
        @invitation.invitation_status = 0
        @invitation.invitation_expired = Time.now + 15.minutes

        
        if @invitation.save
            InvitationMailer.invitation_email(@invitation).deliver_now
            render json: { status: 201, message: "Berhasil dibuat", data:@invitation}, status: 201
            else
            render json: { message: "Gagal", errors: @invitation.errors.full_messages }
        end
    end

    def accept_invitation
        @invitation = Invitation.find_by(invitation_token: params[:invitation_token])
        if @invitation && @invitation.invitation_valid?
          @invitation.accept_invitation!
          render json: { status: 201, message: "Undangan Diterima", data:@invitation}, status: 201
        else
          render json: { message: "Undangan tidak valid"}
        end 
      end

    def set_invitation
        @invitation = Invitation.find_by(id: params[:id])
        return render json: { message: "Undangan Tidak ditemukan"}, status: :not_found if@invitation.nil?
    end

    def invitation_params
        params.require(:invitation).permit(:user_id, :team_id, :invitation_token)
    end
end
