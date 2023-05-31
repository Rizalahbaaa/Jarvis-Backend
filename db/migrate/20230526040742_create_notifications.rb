class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :body
      t.integer :user_id
      t.boolean :read, default: "false"
      t.integer :sender_id
      t.integer :sender_place

      t.timestamps
    end
  end
end
