class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.string :subject
      t.text :description
      t.date :event_date
      t.integer :reminder_date
      t.integer :ringtone_id
      t.timestamps
    end
  end
end
