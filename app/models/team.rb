class Team < ApplicationRecord
has_many :user_team
has_many :user, through: :user_team, dependent: :destroy
has_many :list
has_many :invitation, as: :invitetable

validates :title, presence: true, length: { maximum: 100 }

def new_attributes
 {
   id: self.id,
   title: self.title,
   participant: self.user.map{ |user| user.new_attr}
 }
 end

end
