class Attach < ApplicationRecord
    belongs_to :progress
    
    validates :name, presence: true, length: { maximum: 100 }
    validates :path, presence: true
    validates :progress_id, presence: true
    
    def new_attributes
    {
        id: self.id,
        name: self.name,
        path: self.path,
        progress_id: self.progress_id   
    }
    end
end