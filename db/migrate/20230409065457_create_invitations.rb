class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.integer :type
      t.string :link
      t.integer :status
      t.integer :user_id

      t.timestamps
    end
  end
end
