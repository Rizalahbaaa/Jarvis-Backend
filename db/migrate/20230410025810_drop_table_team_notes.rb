class DropTableTeamNotes < ActiveRecord::Migration[7.0]
  def change
    drop_table :team_notes
    drop_table :user_team_notes
  end
end
