class CreateTeamNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :team_notes do |t|
      t.string :subject
      t.string :description
      t.date :event_date
      t.date :reminder
      t.integer :list_id
      t.integer :ringtone_id

      t.timestamps
    end
  end
end
