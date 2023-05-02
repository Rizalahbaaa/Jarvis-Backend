class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.string :invitation_token
      t.string :invitation_status
      t.date :invitation_expired
      t.references :invitable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
