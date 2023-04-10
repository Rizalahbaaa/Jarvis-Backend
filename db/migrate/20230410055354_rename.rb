class Rename < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions , :status, :transaction_status
  end
end
