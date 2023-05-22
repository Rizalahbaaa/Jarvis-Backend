class CreateNotification < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :description
      t.integer :user_id
      t.integer :user_note_id
      t.integer :user_team_id

      t.timestamps
    end
  end
end
