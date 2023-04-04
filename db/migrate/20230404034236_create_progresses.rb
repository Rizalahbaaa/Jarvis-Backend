class CreateProgresses < ActiveRecord::Migration[7.0]
  def change
    create_table :progresses do |t|
      t.enum :status
      t.bigint :notes_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
