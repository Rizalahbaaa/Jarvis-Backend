class RemoveColumnOnUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :username
    remove_column :users, :phone
    remove_column :users, :job_id
    remove_column :users, :photo
  end
end
