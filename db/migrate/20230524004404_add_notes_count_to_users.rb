class AddNotesCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notes_count, :integer, default: 0
  end
end
