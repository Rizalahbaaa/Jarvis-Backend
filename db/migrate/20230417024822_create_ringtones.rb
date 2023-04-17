class CreateRingtones < ActiveRecord::Migration[7.0]
  def change
    create_table :ringtones do |t|
      t.string :name
      t.text :path

      t.timestamps
    end
  end
end
