class RemoveUserteamColoumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_teams, :invitation_status
    remove_column :user_teams, :invitation_code
  end
end
