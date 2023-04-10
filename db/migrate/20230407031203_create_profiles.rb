class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :job_id
      t.string :phone
      t.text :photo
      t.integer :user_id
      t.timestamps
    end
  end
end
