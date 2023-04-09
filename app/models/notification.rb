class Notification < ApplicationRecord
    belongs_to :note
    belongs_to :user

    validates :title, presence: true, length: { maximum: 100}
    validates :description, presence: true, length: { maximum: 100}
    validates :note_id, presence: true
    validates :user_id, presence: true


    def new_attr
        {
            title: self.title,
            description: self.description,
            note_title: self.note.subject,
            user_id: self.user_id
        }
    end
end
