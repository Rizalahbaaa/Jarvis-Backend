class Api::TeamsController < ApplicationController
  before_action :set_team, only: %i[show update destroy kick_member leave_member]
  before_action :authenticate_request

  def index
    @teams = Team.all
    render json: { success: true, status: 200, data: @teams.map {|team| team.new_attr} }
  end

  def show
    @find_user_team = UserTeam.find_by(user: @current_user, team: @team)
    render json: {message: @team.new_attr, data: @find_user_team}
  end

  # def create
  #   @team = Team.new(team_params)
  #   if @team.save
  #     render json: { success: true, message: 'team created successfully', status: 201, data: @team.new_attributes }, status: 201
  #   else
  #     render json: { success: false, message: 'team created unsuccessfully', status: 422, data: @team.errors }, status: 422
  #   end
  # end

  def create
    @team = Team.new(team_params)
    return unless @team.save

    @user_team = UserTeam.new(team: @team, user: @current_user)
    if @user_team.save
      team_mailer(params[:email])
      render json: { success: true, message: 'team created successfully', status: 201, data: @team.new_attr },
             status: 201
    else
      render json: { success: false, message: 'team created unsuccessfully', status: 422, data: @team.errors },
             status: 422
    end
  end

  def email_valid
    @email = params[:email].downcase
    return @email.errors if @email.blank?

    @results = User.all.where('LOWER(email) LIKE ?', @email)
    @results.each do |result|
      result.email
    end
    render json: { data: @results.map { |result| result.email } }, status: 200
  end

  def team_mailer(emails)
    return unless emails.present?

    emails.each do |email|
      token = set_invite_token
      @user_invite = User.find_by(email: email)
      @invite_team = UserTeam.new(team: @team, user: @user_invite, teaminvitation_token: token[:token], teaminvitation_status:
        token[:status], team_role: token[:role], teaminvitation_expired: token[:expired])
      if @invite_team.save
        puts 'SENDING EMAIL.....'
        InvitationMailer.team_invitation(email, token[:token]).deliver_now
      end
      # binding.pry
    end
  end

  def set_invite_token
    {
      token: SecureRandom.hex(20),
      status: 0,
      role: 1,
      expired: Time.now + 1.day
    }
  end

  def update
    @find_user_team = UserTeam.find_by(user: @current_user, team: @team)
    if @find_user_team.team_role == 'owner' && @find_user_team.user_id != @current_user
      @emails = params[:email]

      if @team.update(team_params)
        
        team_mailer(params[:email]) if params[:email].present?
        
        render json: { success: true, status: 200, message: 'team updated successfully', data: @team.new_attr },
        status: 200
      else
        render json: { success: false, status: 422, message: 'team updated unsuccessfully', data: @team.errors },
               status: 422
      end
    else
      render json: { success: false, message: 'sorry, only owner can update team', status: 422 },
             status: 422
    end
  end
  
  def kick_member
    member_emails = params[:email]
    members = User.where(email: member_emails)
  
    if members.empty?
      render json: { success: false, message: 'Members not found', status: 404 }, status: 404
    elsif members.include?(@current_user)
      render json: { success: false, message: 'You cannot kick yourself', status: 422 }, status: 422
    else
      # Pastikan hanya owner tim yang dapat melakukan kick
      @team = Team.find_by_id(params[:id])
      @find_user_team = UserTeam.find_by(user: @current_user, team: @team, team_role: 'owner').present?
      if @find_user_team == true
        # Cek apakah anggota tersebut adalah anggota dari tim
        user_teams = @team.user_team.where(user: members)
        if user_teams.empty?
          render json: { success: false, message: 'Members are not part of the team', status: 422 }, status: 422
        else
          # Kick member dari tim
          if user_teams.destroy_all
            render json: { success: true, message: 'Members kicked successfully', status: 200 }, status: 200
          else
            render json: { success: false, message: 'Failed to kick members', status: 500 }, status: 500
          end
        end
      else
        render json: { success: false, message: 'sorry, only owner can update team', status: 422, data: @find_user_team },
              status: 422
      end
    end
  end
  
  def leave_member
    @user_team = UserTeam.find_by(user: @current_user, team: @team)
    if @user_team.team_role == 'owner'
      render json: { success: false, message: 'The team owner cannot leave the team', status: 422 }, status: 422
    else
      if @user_team.destroy
        render json: { success: true, message: 'You have left the team successfully', status: 200 }, status: 200
      else
        render json: { success: false, message: 'Failed to leave the team', status: 500 }, status: 500
      end
    end
  end

  def destroy
    @user_team = UserTeam.find_by(user: @current_user, team: @team)
    # binding.pry
    if @user_team.team_role != 'owner'
      render json: { success: false, message: 'sorry, only owner can delete team', status: 422 },
             status: 422
    elsif @user_team.team_role == 'owner' && @user_team.user_id != @current_user && @team.destroy
      render json: { success: true, message: 'team delete successfully', status: 200 },
             status: 200
    else
      render json: { success: false, message: 'team delete unsuccessfully', status: 422, data: @team.errors },
             status: 422
    end
  end

  private
  def set_team
    @team = Team.find_by_id(params[:id])
    return unless @team.nil?
    render json: { status: 404, message: 'team not found' }, status: 404
  end

  def team_params
    params.permit(:title, :photo)
  end
end
