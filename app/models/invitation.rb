class Invitation < ApplicationRecord
    belongs_to :profile
    belongs_to :invitetable, polymorphic: true
    

    enum invitation_status: {
        sent: 0,
        confirm: 1,
        rejected: 2
    }

    validates :link, presence: true
    validates :invitation_status, presence: true
    validates :profile_id, presence: true
    validates :invitetable_id, presence: true
    validates :invitetable_type, presence: true

    def new_attr
        {
            link: self.link,
            invitation_status: self.invitation_status,
            user_name: profile.username,
            invitetable_id: self.invitetable_id,
            invitetable_type: self.invitetable_type
        }
    end  
end
