class ChangeColumnTypePathOnAttach < ActiveRecord::Migration[7.0]
  def change
    change_column :attaches, :path, :json, using: 'path::json'
  end
end