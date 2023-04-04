class List < ApplicationRecord
 belongs_to :team

 validates :title, presence: true, length: { maximum: 100 }
 validates :team_id, presence: true

 def new_attributes
   {
     id: self.id,
     title: self.title,
     team_id: self.team_id   
   }
    end

end
