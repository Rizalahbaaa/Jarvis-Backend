class Folder < ApplicationRecord
    belongs_to :progress

    validates :name, presence: true, length: { maximum: 100 }
    validates :folder, presence: true
    validates :progress_id, presence: true

    def new_attributes
    {
        id: self.id,
        name: self.name,
        folder: self.folder,
        progress_id: self.progress_id   
    }
    end
end