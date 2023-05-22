class AddPhotoOnTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :photo, :text
  end
end
