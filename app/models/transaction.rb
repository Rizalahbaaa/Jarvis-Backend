class Transaction < ApplicationRecord
    belongs_to :product
    belongs_to :user
    belongs_to :user_note
    validates :product_id, presence: true
    validates :profile_id, presence: true
    enum transaction_status: {
        pending: 0,
        processing: 1,
        completed: 2,
        canceled: 3
      }
    def new_attr
        {
            id:,
            product_id:, 
            user_id:,
            user_note_id:, 
            transaction_status:
        }
    end
end
