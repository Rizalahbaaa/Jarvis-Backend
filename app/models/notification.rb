class Notification < ApplicationRecord
    belongs_to :note
    belongs_to :profile

    validates :title, presence: true, length: { maximum: 100}
    validates :description, presence: true, length: { maximum: 100}
    validates :note_id, presence: true
    validates :profile_id, presence: true


    def new_attr
        {
            title: self.title,
            description: self.description,
            note_title: self.note.subject,
            user_name: self.username
        }
    end
end
