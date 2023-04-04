class CreateUserTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :user_teams do |t|
      t.integer :user_id
      t.integer :team_id
      t.string :invitation_code
      t.integer :invitation_status
      t.timestamps
    end
  end
end
