class UserTeamNote < ApplicationRecord
    belongs_to :team_note
    belongs_to :user

    validates :role, presence :true
    validates :team_notes_id, presence :true
    validates :user_id, presence :true

    enum role: {
        owner: 0,
        member: 1
    }

    def new_attr
        {
            id: self.id,
            role: self.role,
            team_notes_id: self.team_notes_id,
            user_id: self.user_id
        }
    end
end
