class Api::UserTeamsController < ApplicationController
  before_action :set_userteam, only: :destroy
  before_action :authenticate_request, except: %i[accept_invitation decline_invitation]

  def index
    @userteam = UserTeam.where(nil)
    # @userteam = UserTeam.where(user_id: 1)#filternya butuh current_id
    render json: { success: true, status: 200, data: @userteam.map {|userteam| userteam.new_attributes} }
  end

  def create
    @userteam = UserTeam.new(userteam_params)

    if @userteam.save
      render json: @userteam.new_attributes, status: :created
    else
      render json: @userteam.errors, status: :unprocessable_entity
    end
  end

  def accept_invitation
    @user_team = UserTeam.find_by(teaminvitation_token: params[:teaminvitation_token])
    team = @user_team.team
    owner = UserTeam.find_by(team: team, team_role: 'owner')
    member = @user_team.user

    if @user_team && @user_team.invitation_valid?
      @user_team.accept_invitation!
      Notification.create(
        title: "menerima",
        body: 'nil',
        user_id: owner.user.id,
        sender_id: member.id,
        sender_place: team.id,
        notif_type: 3
      )
      render json: { status: 200, message: "Undangan Diterima"}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def accept_invitation_email
    @user_team = UserTeam.find_by(teaminvitation_token: params[:teaminvitation_token])

    if @user_team && @user_team.invitation_valid?
      @user_team.accept_invitation!
      render json: { status: 200, message: "Undangan Diterima"}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def decline_invitation
    @user_team = UserTeam.find_by(teaminvitation_token: params[:teaminvitation_token])
    team = @user_team.team
    owner = UserTeam.find_by(team: team, team_role: 'owner')
    member = @user_team.user

    if @user_team && @user_team.invitation_valid?
      @user_team.decline_invitation!
      Notification.create(
        title: "menolak",
        body: 'nil',
        user_id: owner.user.id,
        sender_id: member.id,
        sender_place: team.id,
        notif_type: 3
      )
      render json: { status: 200, message: "Undangan Ditolak"}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def decline_invitation_email
    @user_team = UserTeam.find_by(teaminvitation_token: params[:teaminvitation_token])

    if @user_team && @user_team.invitation_valid?
      @user_team.decline_invitation!
      render json: { status: 200, message: "Undangan Ditolak"}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def destroy
    @user_team = UserTeam.find_by_id(params[:id])
    if @user_team.destroy
      render json: { success: true, status: 200, message: 'user_team deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'user_team deleted unsuccessfully' }, status: 422
    end
  end

  private

  def set_userteam
    @userteam = UserTeam.find_by_id(params[:id])
    return unless @userteam.nil?

    render json: { error: 'Team not found' }, status: :not_found
  end

  def userteam_params
    params.permit(
      :profile_id,
      :team_id
    )
  end
end
