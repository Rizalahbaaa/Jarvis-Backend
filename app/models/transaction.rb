class Transaction < ApplicationRecord
    belongs_to :product, optional: true
    belongs_to :user
    belongs_to :user_note, optional: true
  
    validates :product_id, presence: true
    validates :user_note_id, presence: true
    validates :user_id, presence: true
    validates :point, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :point_type, inclusion: { in: %w[earned redeemed] }

    
    enum transaction_status: {
      processing: 1,
      completed: 2,
      canceled: 3
    }
    
    def new_attr
      {
        id: self.id,
        product_id: self.product_id,
        user_id: self.user_id,
        user_note_id: self.user_note_id,
        transaction_status: self.transaction_status,
        point: self.point,
        point_type: self.point_type,
        earned: self.user.transactions.where(point_type: 'earned').sum(:point),
        redeemed: self.user.transactions.where(point_type: 'redeemed').sum(:point)
    }
    end

    def name
        "#{self.point_type} #{self.point}"
    end
  end