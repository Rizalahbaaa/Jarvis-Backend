class Attach < ApplicationRecord
    mount_uploaders :path, AttachUploader

    belongs_to :user_note
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :path, presence: true
    validates :user_note_id, presence: true
    
    def new_attr
    {
        id:,
        name:,
        path:,
        user_note_id:
    }
    end
end