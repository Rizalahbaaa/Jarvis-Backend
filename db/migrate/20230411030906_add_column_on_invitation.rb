class AddColumnOnInvitation < ActiveRecord::Migration[7.0]
  def change
    add_reference :invitations, :invitetable, polymorphic: true, index: true
  end
end
