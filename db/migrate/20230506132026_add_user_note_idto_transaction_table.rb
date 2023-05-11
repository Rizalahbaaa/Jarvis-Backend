class AddUserNoteIdtoTransactionTable < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions ,:user_note_id, :bigint
  end
end
