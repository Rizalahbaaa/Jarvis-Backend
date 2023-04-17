class Api::InvitationsController < ApplicationController
    def index
        @invitation = Invitation.all
        render json: @invitation.map { |invitation| invitation.new_attr }
    end

    def show
        render json: Invitation.find(params[:id])
    end

    def create
        @invitation = Invitation.new(invitation_params)
        if @invitation.save
            render json: @invitation.new_attr, status: :created
        else
            render json: @invitation.errors, status: :unprocessable_entity
        end
    end

    def update
        @invitation = Invitation.find(params[:id])
        if @invitation.update(invitation_params)
            render json: @invitation.new_attr
        else
            render json: @invitation.errors, status: :unprocessable_entity
        end
    end

    def destroy
        room = Invitation.find(params[:id])
        room.destroy
        render json: "berhasil di hapus"
    end
    

    private
    def set_invitation
        @invitation = Invitation.find(params[:id])
    end

    def invitation_params
        params.require(:invitation).permit(
         :invitetable_id,:invitetable_type, :link, :invitation_status, :profile_id)
    end
end
