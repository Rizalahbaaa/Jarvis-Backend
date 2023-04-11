class Attach < ApplicationRecord
    belongs_to :progress
    
    validates :name, presence: true, length: { maximum: 100 }
    validates :path, presence: true
    validates :progress_id, presence: true
    
    def new_attr
    {
        id:,
        name:,
        path:,
        progress: progress.new_attr
    }
    end
end