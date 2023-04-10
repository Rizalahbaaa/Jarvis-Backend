class RenameAllColumnContainUserIdToProfileId < ActiveRecord::Migration[7.0]
  def change
    rename_column :user_notes, :user_id, :profile_id
    rename_column :user_teams, :user_id, :profile_id
    rename_column :progresses, :user_id, :profile_id
  end
end
