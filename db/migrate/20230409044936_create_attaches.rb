class CreateAttaches < ActiveRecord::Migration[7.0]
  def change
    create_table :attaches do |t|
      t.string :name
      t.text :path
      t.integer :progress_id
      
      t.timestamps
    end
  end
end
