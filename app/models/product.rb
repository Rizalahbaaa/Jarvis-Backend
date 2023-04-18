class Product < ApplicationRecord
    has_many :transactions
    has_many :users, through: :transactions
    validates :name, :reward, :terms, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
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
