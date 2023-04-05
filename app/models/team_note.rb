class TeamNote < ApplicationRecord
    belongs_to :list
    belongs_to :ringtone
    has_many :user_team_note
    has_many :notification

    validates :list_id, presence :true
    validates :ringtones_id, presence :true
    validates :subject, presence :true
    validates :event_date, presence :true
    validates :reminders,presence :true

    def new_attr
        {   
            id: self.id,
            subject: self.subject,
            description: self.description,
            event_date: self.event_date,
            reminder: self.reminder,
            list_id: self.list_id,
            ringtone_id: self.ringtones_id
        }
    end
end

