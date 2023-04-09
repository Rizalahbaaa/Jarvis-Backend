class RemoveUserteamColoumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :invitation_code, :invitation_status
  end
end
