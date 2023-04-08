class Transaction < ApplicationRecord
    belongs_to :product
    belongs_to :user
    belongs_to :progress
    validates :product_id, presence: true
    validates :user_id, presence: true
    enum status: [:pending, :processing, :completed]

end
