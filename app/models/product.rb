class Product < ApplicationRecord
    has_many :transactions
    
    validates :image , presence: true
    validates :title , presence: true
    validates :reward , presence: true
    validates :sk , presence: true
    validates :points , presence: true

    def user_attr 
        {
          "id": self.id,
          "image": self.image,
          "title": self.tittle,
          "reward": self.reward,
          "sk": self.sk,
          "points": self.points
        }
    end
end
