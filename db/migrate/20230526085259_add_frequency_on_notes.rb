class AddFrequencyOnNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :frequency, :integer
  end
end
