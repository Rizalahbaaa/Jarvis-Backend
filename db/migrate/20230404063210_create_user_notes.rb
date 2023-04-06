class CreateUserNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_notes do |t|
      t.integer :note_id
      t.integer :user_id
      t.integer :role, default: 0
      t.timestamps
    end
  end
end
