class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.string :subject
      t.text :description
      t.datetime :event_date
      t.integer :ringtone_id
      t.integer :column_id
      t.integer :note_type, default: 0
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
