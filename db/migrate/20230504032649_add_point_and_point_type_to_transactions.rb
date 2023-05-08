class AddPointAndPointTypeToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :point, :integer
    add_column :transactions, :point_type, :string
  end
end
