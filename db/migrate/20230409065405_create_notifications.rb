class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :description
      t.integer :note_id
      t.integer :user_id

      t.timestamps
    end
  end
end
