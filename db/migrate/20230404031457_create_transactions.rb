class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.bigint :product_id
      t.bigint :profile_id
      t.bigint :progress_id
      t.integer :status, null: false, default: 0, enum_type: 'integer'

      t.timestamps
    end
  end
end
