class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :subject
      t.text :description
      t.string :label
      t.integer :column_id
      t.timestamps
    end
  end
end
