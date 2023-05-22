class Notification < ApplicationRecord
    # include Noticed::Model
    belongs_to :user
    belongs_to :user_note
    belongs_to :user_team

    validates :title, presence: true, length: { maximum: 50}
    validates :description, presence: true, length: { maximum: 100}
    validates :user_id, presence: true
    validates :user_note_id, presence: true
    validates :user_team_id, presence: true


    def new_attr
        {
            title: self.title,
            description: self.description,
            user: user.username,
            user_note: self.user_note_id,
            user_team: self.user_team_id
        }
    end
end
