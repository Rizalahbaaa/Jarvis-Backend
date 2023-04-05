class CreateUserTeamNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_team_notes do |t|
      t.integer :role
      t.integer :user_id
      t.integer :team_notes_id

      t.timestamps
    end
  end
end
