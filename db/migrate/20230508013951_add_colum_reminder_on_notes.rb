class AddColumReminderOnNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :reminder, :datetime
  end
end
