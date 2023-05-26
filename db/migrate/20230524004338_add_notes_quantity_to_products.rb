class AddNotesQuantityToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :notes_quantity, :integer, default: 0
  end
end
