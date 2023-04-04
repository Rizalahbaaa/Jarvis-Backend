class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.text :folder
      t.bigint :progress_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
