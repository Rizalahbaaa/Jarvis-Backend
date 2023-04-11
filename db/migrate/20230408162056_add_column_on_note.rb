class AddColumnOnNote < ActiveRecord::Migration[7.0]
  def up
    add_column :notes, :list_id, :integer
    add_column :notes, :note_type, :integer
    change_column :notes, :event_date, :datetime
  end

  # def down
  #   change_column :notes, :list_id, :integer
  #   change_column :notes, :event_date, :datetime
  # end
end
