class Attach < ApplicationRecord
    belongs_to :user_note
    
    validates :name, presence: true, length: { maximum: 100 }
    validates :path, presence: true
    validates :user_note_id, presence: true
    
    def new_attr
    {
        id:,
        name:,
        path:,
        user_note: user_note.new_attr
    }
    end
end