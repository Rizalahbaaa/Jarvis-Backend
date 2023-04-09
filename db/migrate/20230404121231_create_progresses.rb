class CreateProgresses < ActiveRecord::Migration[7.0]
  def change
    create_table :progresses do |t|
      t.integer :status, default: 0
      t.integer :notes_id
      t.integer :user_id

      t.timestamps
    end
  end
end
