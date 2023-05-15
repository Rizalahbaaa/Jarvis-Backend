class RemoveNameOnAttach < ActiveRecord::Migration[7.0]
  def change
    remove_column :attaches, :name
  end
end
