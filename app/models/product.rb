class Product < ApplicationRecord
    has_many :transactions
    has_many :users, through: :transactions
    
    validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :terms, presence: true ,length: { maximum: 100 }
    validates :reward, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :price, presence: true, numericality: { greater_than: 0 }
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
