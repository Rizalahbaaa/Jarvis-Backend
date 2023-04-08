class Product < ApplicationRecord
    has_many :transactions
    has_many :user, through: :transaction
    validates :name , presence: true
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    def new_attr 
        {
          id:,
          name: ,
          reward: ,
          terms: ,
          price:
        }
    end
end
