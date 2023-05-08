class RemoveColumReminderOnUserNotes < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_notes, :reminder
  end
end
