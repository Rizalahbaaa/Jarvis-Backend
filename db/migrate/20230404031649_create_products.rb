class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.text :image
      t.string :title
      t.string :reward
      t.text :sk
      t.bigint :points

      t.timestamps
    end
  end
end
