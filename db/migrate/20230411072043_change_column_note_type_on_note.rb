class ChangeColumnNoteTypeOnNote < ActiveRecord::Migration[7.0]
  def change
    change_column :notes, :note_type, :integer, default: 0
  end
end
