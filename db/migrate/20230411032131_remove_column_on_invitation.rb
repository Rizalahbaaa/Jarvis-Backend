class RemoveColumnOnInvitation < ActiveRecord::Migration[7.0]
  def change
    remove_column :invitations, :invitation_type
  end
end
