class AddInvitationColumnOnUserTeamTable < ActiveRecord::Migration[7.0]
  def change
    add_column :user_teams, :teaminvitation_token, :string
    add_column :user_teams, :teaminvitation_status, :integer
    add_column :user_teams, :teaminvitation_expired, :timestamp
    add_column :user_teams, :team_role, :integer, default: 0
  end
end
