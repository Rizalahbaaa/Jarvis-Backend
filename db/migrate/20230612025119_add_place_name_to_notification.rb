class AddPlaceNameToNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :place_name, :string
  end
end
