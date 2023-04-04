class UserTeam < ApplicationRecord
belongs_to :team
belongs_to :user

validates :user_id, presence: true
validates :team_id, presence: true


def new_attributesr
    {
     id: self.id,
     user_id: self.user_id,
     team_id: self.team_id,
     invitation_code: self.invitation_code,
     invitation_status: self.invitation_status
          
      }
    end


end
