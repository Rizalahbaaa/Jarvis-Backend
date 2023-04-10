class Transaction < ApplicationRecord
    belongs_to :product
    belongs_to :profile
    belongs_to :progress
    validates :product_id, presence: true
    validates :profile_id, presence: true
    enum transaction_status: [:pending, :processing, :completed]

    def new_attr
        {
            id:,
            product_id:, 
            progress_id:,
            profile_id:, 
            transaction_status:
        }
    end
end
