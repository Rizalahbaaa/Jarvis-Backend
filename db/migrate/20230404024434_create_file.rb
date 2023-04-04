class CreateFile < ActiveRecord::Migration[7.0]
  def change
    create_table :files do |t|
      t.string :name
      t.text :file
      t.bigint :progress_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
