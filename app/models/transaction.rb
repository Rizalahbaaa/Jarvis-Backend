class Transaction < ApplicationRecord
    belongs_to :product
    belongs_to :user
    validates :product_id, presence: true
    validates :user_id, presence: true
    enum status: [:pending, :processing, :completed]

    def new_attr
        {
            id:,
            product_id:, 
            user_id:, 
            status:
        }
    end
end
