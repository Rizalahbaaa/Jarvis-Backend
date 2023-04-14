class DropAllTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :attaches
    drop_table :invitations
    drop_table :jobs
    drop_table :lists
    drop_table :notes
    drop_table :notifications
    drop_table :profiles
    drop_table :progresses
    drop_table :reminders
    drop_table :ringtones
    drop_table :transactions
    drop_table :user_notes
    drop_table :user_teams
    drop_table :users
  end
end
