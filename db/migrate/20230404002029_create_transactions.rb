class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.bigint :product_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
