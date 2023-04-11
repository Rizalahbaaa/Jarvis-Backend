class RenameColumnOnNotificationAndInvitation < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :user_id, :profile_id
    rename_column :invitations, :user_id, :profile_id
    rename_column :invitations, :type, :invitation_type
    rename_column :invitations, :status, :invitation_status
    change_column :invitations, :invitation_status, :string, default: 0
  end
end
