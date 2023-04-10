class AddColumnOnNote < ActiveRecord::Migration[7.0]
  def up
    change_column :notes, :list_id, :integer
    rename_column :notes, :type, :note_type
    change_column :notes, :event_date, :datetime
  end

  def down
    change_column :notes, :list_id, :integer
    change_column :notes, :type, :integer
    change_column :notes, :event_date, :datetime
  end
end
