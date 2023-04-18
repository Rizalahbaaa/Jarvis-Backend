class CreateColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :columns do |t|
      t.string :title
      t.integer :team_id
      t.timestamps
    end
  end
end
