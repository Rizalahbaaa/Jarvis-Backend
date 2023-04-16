class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :phone
      t.string :job
      t.text :photo
      t.string :password_digest
      t.timestamps
    end
  end
end
