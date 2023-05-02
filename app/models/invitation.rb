class Invitation < ApplicationRecord
    # belongs_to :invitetable, polymorphic: true
    

    # enum :invitation_status, {pending: 0, Accepted: 1, Rejected: 2 }


    # def invitation_valid?
    #     self.invitation_status == "pending" && self.invitation_expired > Time.now
    # end

    # def accept_invitation!
    #    self.invitation_status = 1
    #    save!
    # end

    # validates :invitation_status, presence: true
    # validates :invitetable_id, presence: true
    # validates :invitetable_type, presence: true

end
