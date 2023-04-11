class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :reward
      t.text :terms
      t.bigint :price

      t.timestamps
    end
  end
end
