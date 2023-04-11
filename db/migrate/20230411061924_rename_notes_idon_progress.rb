class RenameNotesIdonProgress < ActiveRecord::Migration[7.0]
  def change
    rename_column :progresses, :notes_id, :note_id
  end
end
