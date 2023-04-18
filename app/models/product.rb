class Product < ApplicationRecord
    has_many :transactions
    has_many :users, through: :transactions
    validates :name , presence: true
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :reward, presence: true
    validates :terms, presence: true
    def new_attr
        {
          id:,
          name: ,
          reward: ,
          terms: ,
          price: ,
          
        }
    end
end
