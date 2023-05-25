class Transaction < ApplicationRecord
    belongs_to :product, optional: true
    belongs_to :user
    belongs_to :user_note, optional: true
    
    validates :user_id, presence: true
    validates :point, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :point_type, inclusion: { in: %w[earned redeemed] }

    after_create :update_user_notes_count
    # enum transaction_status: {
    #   processing: 1,
    #   completed: 2,
    #   canceled: 3
    # }
    def update_user_notes_count
      if self.point_type == 'redeemed'
        user.update_notes_count(self.product.notes_quantity)
      elsif self.point_type == 'created'
        user.deduct_notes_count(self.product.notes_quantity)
      end
    end

    def new_attr
      attributes = {
        id: self.id,
        user_id: self.user_id,
        user_note_id: self.user_note_id,
        transaction_status: self.transaction_status,
        point: point,
        point_type: self.point_type
      }
      if self.point_type == 'redeemed'
        product = Product.find_by(id: self.product_id)
        attributes[:product_id] = self.product_id
        attributes[:product_name] = product.name if product
      end
      attributes.delete(:product_id) if self.point_type == 'earned'
      attributes.delete(:user_note_id) if self.point_type == 'redeemed'
      attributes
    end
    def name
        "#{self.point_type} #{self.point}"
    end
  end