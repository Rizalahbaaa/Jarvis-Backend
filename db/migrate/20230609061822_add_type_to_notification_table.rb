class AddTypeToNotificationTable < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :notif_type, :integer, default: 0
  end
end
