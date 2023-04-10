class Progress < ApplicationRecord
    belongs_to :user
    belongs_to :note, class_name: "Note", foreign_key: "notes_id"
    # has_one :transactions
    has_many :attach

    validates :status, presence: true
    validates :notes_id, presence: true
    validates :user_id, presence: true

    enum status: { on_progress: 0, completed: 1 }

    def new_attributes
    {
        id: self.id,
        status: self.status,
        notes_id: self.notes_id,
        user_id: self.user_id   
    }
    end
end