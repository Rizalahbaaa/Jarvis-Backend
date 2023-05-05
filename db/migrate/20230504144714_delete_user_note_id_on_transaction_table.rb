class DeleteUserNoteIdOnTransactionTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :user_note_id
  end
end
