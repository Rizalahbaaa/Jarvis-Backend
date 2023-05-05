class AddInvitationColumnOnUserNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :user_notes, :noteinvitation_token, :string
    add_column :user_notes, :noteinvitation_status, :integer
    add_column :user_notes, :noteinvitation_expired, :timestamp
  end
end
