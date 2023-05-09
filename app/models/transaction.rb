class Transaction < ApplicationRecord
    belongs_to :product
    belongs_to :user
  
    validates :product_id, presence: true
    validates :user_id, presence: true
    validates :point, numericality: { only_integer: true, greater_than: 0 }
    validates :point_type, inclusion: { in: %w[earned redeemed] }
  
    enum transaction_status: {
      processing: 1,
      completed: 2,
      canceled: 3
    }

    def new_attr
        {
          id: ,
          product_id: , 
          user_id: ,
          transaction_status: ,
          point: ,
          point_type: 
        }
      end

    def points
      self[:points] || product.price
    end
  end